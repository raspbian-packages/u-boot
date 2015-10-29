/*
 * Copyright (c) 2014 Google, Inc
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <dm.h>
#include <dm/device-internal.h>
#include <dm/root.h>
#include <dm/test.h>
#include <dm/uclass-internal.h>
#include <dm/util.h>
#include <test/ut.h>

DECLARE_GLOBAL_DATA_PTR;

struct dm_test_parent_platdata {
	int count;
	int bind_flag;
	int uclass_bind_flag;
};

enum {
	FLAG_CHILD_PROBED	= 10,
	FLAG_CHILD_REMOVED	= -7,
};

static struct dm_test_state *test_state;

static int testbus_drv_probe(struct udevice *dev)
{
	return dm_scan_fdt_node(dev, gd->fdt_blob, dev->of_offset, false);
}

static int testbus_child_post_bind(struct udevice *dev)
{
	struct dm_test_parent_platdata *plat;

	plat = dev_get_parent_platdata(dev);
	plat->bind_flag = 1;
	plat->uclass_bind_flag = 2;

	return 0;
}

static int testbus_child_pre_probe(struct udevice *dev)
{
	struct dm_test_parent_data *parent_data = dev_get_parentdata(dev);

	parent_data->flag += FLAG_CHILD_PROBED;

	return 0;
}

static int testbus_child_pre_probe_uclass(struct udevice *dev)
{
	struct dm_test_priv *priv = dev_get_priv(dev);

	priv->uclass_flag++;

	return 0;
}

static int testbus_child_post_remove(struct udevice *dev)
{
	struct dm_test_parent_data *parent_data = dev_get_parentdata(dev);
	struct dm_test_state *dms = test_state;

	parent_data->flag += FLAG_CHILD_REMOVED;
	if (dms)
		dms->removed = dev;

	return 0;
}

static const struct udevice_id testbus_ids[] = {
	{
		.compatible = "denx,u-boot-test-bus",
		.data = DM_TEST_TYPE_FIRST },
	{ }
};

U_BOOT_DRIVER(testbus_drv) = {
	.name	= "testbus_drv",
	.of_match	= testbus_ids,
	.id	= UCLASS_TEST_BUS,
	.probe	= testbus_drv_probe,
	.child_post_bind = testbus_child_post_bind,
	.priv_auto_alloc_size = sizeof(struct dm_test_priv),
	.platdata_auto_alloc_size = sizeof(struct dm_test_pdata),
	.per_child_auto_alloc_size = sizeof(struct dm_test_parent_data),
	.per_child_platdata_auto_alloc_size =
			sizeof(struct dm_test_parent_platdata),
	.child_pre_probe = testbus_child_pre_probe,
	.child_post_remove = testbus_child_post_remove,
};

UCLASS_DRIVER(testbus) = {
	.name		= "testbus",
	.id		= UCLASS_TEST_BUS,
	.flags		= DM_UC_FLAG_SEQ_ALIAS,
	.child_pre_probe = testbus_child_pre_probe_uclass,
};

/* Test that we can probe for children */
static int dm_test_bus_children(struct unit_test_state *uts)
{
	int num_devices = 6;
	struct udevice *bus;
	struct uclass *uc;

	ut_assertok(uclass_get(UCLASS_TEST_FDT, &uc));
	ut_asserteq(num_devices, list_count_items(&uc->dev_head));

	/* Probe the bus, which should yield 3 more devices */
	ut_assertok(uclass_get_device(UCLASS_TEST_BUS, 0, &bus));
	num_devices += 3;

	ut_assertok(uclass_get(UCLASS_TEST_FDT, &uc));
	ut_asserteq(num_devices, list_count_items(&uc->dev_head));

	ut_assert(!dm_check_devices(uts, num_devices));

	return 0;
}
DM_TEST(dm_test_bus_children, DM_TESTF_SCAN_PDATA | DM_TESTF_SCAN_FDT);

/* Test our functions for accessing children */
static int dm_test_bus_children_funcs(struct unit_test_state *uts)
{
	const void *blob = gd->fdt_blob;
	struct udevice *bus, *dev;
	int node;

	ut_assertok(uclass_get_device(UCLASS_TEST_BUS, 0, &bus));

	/* device_get_child() */
	ut_assertok(device_get_child(bus, 0, &dev));
	ut_asserteq(-ENODEV, device_get_child(bus, 4, &dev));
	ut_assertok(device_get_child_by_seq(bus, 5, &dev));
	ut_assert(dev->flags & DM_FLAG_ACTIVATED);
	ut_asserteq_str("c-test@5", dev->name);

	/* Device with sequence number 0 should be accessible */
	ut_asserteq(-ENODEV, device_find_child_by_seq(bus, -1, true, &dev));
	ut_assertok(device_find_child_by_seq(bus, 0, true, &dev));
	ut_assert(!(dev->flags & DM_FLAG_ACTIVATED));
	ut_asserteq(-ENODEV, device_find_child_by_seq(bus, 0, false, &dev));
	ut_assertok(device_get_child_by_seq(bus, 0, &dev));
	ut_assert(dev->flags & DM_FLAG_ACTIVATED);

	/* There is no device with sequence number 2 */
	ut_asserteq(-ENODEV, device_find_child_by_seq(bus, 2, false, &dev));
	ut_asserteq(-ENODEV, device_find_child_by_seq(bus, 2, true, &dev));
	ut_asserteq(-ENODEV, device_get_child_by_seq(bus, 2, &dev));

	/* Looking for something that is not a child */
	node = fdt_path_offset(blob, "/junk");
	ut_asserteq(-ENODEV, device_find_child_by_of_offset(bus, node, &dev));
	node = fdt_path_offset(blob, "/d-test");
	ut_asserteq(-ENODEV, device_find_child_by_of_offset(bus, node, &dev));

	/* Find a valid child */
	node = fdt_path_offset(blob, "/some-bus/c-test@1");
	ut_assertok(device_find_child_by_of_offset(bus, node, &dev));
	ut_assert(!(dev->flags & DM_FLAG_ACTIVATED));
	ut_assertok(device_get_child_by_of_offset(bus, node, &dev));
	ut_assert(dev->flags & DM_FLAG_ACTIVATED);

	return 0;
}
DM_TEST(dm_test_bus_children_funcs, DM_TESTF_SCAN_PDATA | DM_TESTF_SCAN_FDT);

/* Test that we can iterate through children */
static int dm_test_bus_children_iterators(struct unit_test_state *uts)
{
	struct udevice *bus, *dev, *child;

	/* Walk through the children one by one */
	ut_assertok(uclass_get_device(UCLASS_TEST_BUS, 0, &bus));
	ut_assertok(device_find_first_child(bus, &dev));
	ut_asserteq_str("c-test@5", dev->name);
	ut_assertok(device_find_next_child(&dev));
	ut_asserteq_str("c-test@0", dev->name);
	ut_assertok(device_find_next_child(&dev));
	ut_asserteq_str("c-test@1", dev->name);
	ut_assertok(device_find_next_child(&dev));
	ut_asserteq_ptr(dev, NULL);

	/* Move to the next child without using device_find_first_child() */
	ut_assertok(device_find_child_by_seq(bus, 5, true, &dev));
	ut_asserteq_str("c-test@5", dev->name);
	ut_assertok(device_find_next_child(&dev));
	ut_asserteq_str("c-test@0", dev->name);

	/* Try a device with no children */
	ut_assertok(device_find_first_child(dev, &child));
	ut_asserteq_ptr(child, NULL);

	return 0;
}
DM_TEST(dm_test_bus_children_iterators,
	DM_TESTF_SCAN_PDATA | DM_TESTF_SCAN_FDT);

/* Test that the bus can store data about each child */
static int test_bus_parent_data(struct unit_test_state *uts)
{
	struct dm_test_parent_data *parent_data;
	struct udevice *bus, *dev;
	struct uclass *uc;
	int value;

	ut_assertok(uclass_get_device(UCLASS_TEST_BUS, 0, &bus));

	/* Check that parent data is allocated */
	ut_assertok(device_find_child_by_seq(bus, 0, true, &dev));
	ut_asserteq_ptr(NULL, dev_get_parentdata(dev));
	ut_assertok(device_get_child_by_seq(bus, 0, &dev));
	parent_data = dev_get_parentdata(dev);
	ut_assert(NULL != parent_data);

	/* Check that it starts at 0 and goes away when device is removed */
	parent_data->sum += 5;
	ut_asserteq(5, parent_data->sum);
	device_remove(dev);
	ut_asserteq_ptr(NULL, dev_get_parentdata(dev));

	/* Check that we can do this twice */
	ut_assertok(device_get_child_by_seq(bus, 0, &dev));
	parent_data = dev_get_parentdata(dev);
	ut_assert(NULL != parent_data);
	parent_data->sum += 5;
	ut_asserteq(5, parent_data->sum);

	/* Add parent data to all children */
	ut_assertok(uclass_get(UCLASS_TEST_FDT, &uc));
	value = 5;
	uclass_foreach_dev(dev, uc) {
		/* Ignore these if they are not on this bus */
		if (dev->parent != bus) {
			ut_asserteq_ptr(NULL, dev_get_parentdata(dev));
			continue;
		}
		ut_assertok(device_probe(dev));
		parent_data = dev_get_parentdata(dev);

		parent_data->sum = value;
		value += 5;
	}

	/* Check it is still there */
	value = 5;
	uclass_foreach_dev(dev, uc) {
		/* Ignore these if they are not on this bus */
		if (dev->parent != bus)
			continue;
		parent_data = dev_get_parentdata(dev);

		ut_asserteq(value, parent_data->sum);
		value += 5;
	}

	return 0;
}
/* Test that the bus can store data about each child */
static int dm_test_bus_parent_data(struct unit_test_state *uts)
{
	return test_bus_parent_data(uts);
}
DM_TEST(dm_test_bus_parent_data, DM_TESTF_SCAN_PDATA | DM_TESTF_SCAN_FDT);

/* As above but the size is controlled by the uclass */
static int dm_test_bus_parent_data_uclass(struct unit_test_state *uts)
{
	struct driver *drv;
	struct udevice *bus;
	int size;
	int ret;

	/* Set the driver size to 0 so that the uclass size is used */
	ut_assertok(uclass_find_device(UCLASS_TEST_BUS, 0, &bus));
	drv = (struct driver *)bus->driver;
	size = drv->per_child_auto_alloc_size;
	bus->uclass->uc_drv->per_child_auto_alloc_size = size;
	drv->per_child_auto_alloc_size = 0;
	ret = test_bus_parent_data(uts);
	if (ret)
		return ret;
	bus->uclass->uc_drv->per_child_auto_alloc_size = 0;
	drv->per_child_auto_alloc_size = size;

	return 0;
}
DM_TEST(dm_test_bus_parent_data_uclass,
	DM_TESTF_SCAN_PDATA | DM_TESTF_SCAN_FDT);

/* Test that the bus ops are called when a child is probed/removed */
static int dm_test_bus_parent_ops(struct unit_test_state *uts)
{
	struct dm_test_parent_data *parent_data;
	struct dm_test_state *dms = uts->priv;
	struct udevice *bus, *dev;
	struct uclass *uc;

	test_state = dms;
	ut_assertok(uclass_get_device(UCLASS_TEST_BUS, 0, &bus));
	ut_assertok(uclass_get(UCLASS_TEST_FDT, &uc));

	uclass_foreach_dev(dev, uc) {
		/* Ignore these if they are not on this bus */
		if (dev->parent != bus)
			continue;
		ut_asserteq_ptr(NULL, dev_get_parentdata(dev));

		ut_assertok(device_probe(dev));
		parent_data = dev_get_parentdata(dev);
		ut_asserteq(FLAG_CHILD_PROBED, parent_data->flag);
	}

	uclass_foreach_dev(dev, uc) {
		/* Ignore these if they are not on this bus */
		if (dev->parent != bus)
			continue;
		parent_data = dev_get_parentdata(dev);
		ut_asserteq(FLAG_CHILD_PROBED, parent_data->flag);
		ut_assertok(device_remove(dev));
		ut_asserteq_ptr(NULL, dev_get_parentdata(dev));
		ut_asserteq_ptr(dms->removed, dev);
	}
	test_state = NULL;

	return 0;
}
DM_TEST(dm_test_bus_parent_ops, DM_TESTF_SCAN_PDATA | DM_TESTF_SCAN_FDT);

static int test_bus_parent_platdata(struct unit_test_state *uts)
{
	struct dm_test_parent_platdata *plat;
	struct udevice *bus, *dev;
	int child_count;

	/* Check that the bus has no children */
	ut_assertok(uclass_find_device(UCLASS_TEST_BUS, 0, &bus));
	device_find_first_child(bus, &dev);
	ut_asserteq_ptr(NULL, dev);

	ut_assertok(uclass_get_device(UCLASS_TEST_BUS, 0, &bus));

	for (device_find_first_child(bus, &dev), child_count = 0;
	     dev;
	     device_find_next_child(&dev)) {
		/* Check that platform data is allocated */
		plat = dev_get_parent_platdata(dev);
		ut_assert(plat != NULL);

		/*
		 * Check that it is not affected by the device being
		 * probed/removed
		 */
		plat->count++;
		ut_asserteq(1, plat->count);
		device_probe(dev);
		device_remove(dev);

		ut_asserteq_ptr(plat, dev_get_parent_platdata(dev));
		ut_asserteq(1, plat->count);
		ut_assertok(device_probe(dev));
		child_count++;
	}
	ut_asserteq(3, child_count);

	/* Removing the bus should also have no effect (it is still bound) */
	device_remove(bus);
	for (device_find_first_child(bus, &dev), child_count = 0;
	     dev;
	     device_find_next_child(&dev)) {
		/* Check that platform data is allocated */
		plat = dev_get_parent_platdata(dev);
		ut_assert(plat != NULL);
		ut_asserteq(1, plat->count);
		child_count++;
	}
	ut_asserteq(3, child_count);

	/* Unbind all the children */
	do {
		device_find_first_child(bus, &dev);
		if (dev)
			device_unbind(dev);
	} while (dev);

	/* Now the child platdata should be removed and re-added */
	device_probe(bus);
	for (device_find_first_child(bus, &dev), child_count = 0;
	     dev;
	     device_find_next_child(&dev)) {
		/* Check that platform data is allocated */
		plat = dev_get_parent_platdata(dev);
		ut_assert(plat != NULL);
		ut_asserteq(0, plat->count);
		child_count++;
	}
	ut_asserteq(3, child_count);

	return 0;
}

/* Test that the bus can store platform data about each child */
static int dm_test_bus_parent_platdata(struct unit_test_state *uts)
{
	return test_bus_parent_platdata(uts);
}
DM_TEST(dm_test_bus_parent_platdata, DM_TESTF_SCAN_PDATA | DM_TESTF_SCAN_FDT);

/* As above but the size is controlled by the uclass */
static int dm_test_bus_parent_platdata_uclass(struct unit_test_state *uts)
{
	struct udevice *bus;
	struct driver *drv;
	int size;
	int ret;

	/* Set the driver size to 0 so that the uclass size is used */
	ut_assertok(uclass_find_device(UCLASS_TEST_BUS, 0, &bus));
	drv = (struct driver *)bus->driver;
	size = drv->per_child_platdata_auto_alloc_size;
	bus->uclass->uc_drv->per_child_platdata_auto_alloc_size = size;
	drv->per_child_platdata_auto_alloc_size = 0;
	ret = test_bus_parent_platdata(uts);
	if (ret)
		return ret;
	bus->uclass->uc_drv->per_child_platdata_auto_alloc_size = 0;
	drv->per_child_platdata_auto_alloc_size = size;

	return 0;
}
DM_TEST(dm_test_bus_parent_platdata_uclass,
	DM_TESTF_SCAN_PDATA | DM_TESTF_SCAN_FDT);

/* Test that the child post_bind method is called */
static int dm_test_bus_child_post_bind(struct unit_test_state *uts)
{
	struct dm_test_parent_platdata *plat;
	struct udevice *bus, *dev;
	int child_count;

	ut_assertok(uclass_get_device(UCLASS_TEST_BUS, 0, &bus));
	for (device_find_first_child(bus, &dev), child_count = 0;
	     dev;
	     device_find_next_child(&dev)) {
		/* Check that platform data is allocated */
		plat = dev_get_parent_platdata(dev);
		ut_assert(plat != NULL);
		ut_asserteq(1, plat->bind_flag);
		child_count++;
	}
	ut_asserteq(3, child_count);

	return 0;
}
DM_TEST(dm_test_bus_child_post_bind, DM_TESTF_SCAN_PDATA | DM_TESTF_SCAN_FDT);

/* Test that the child post_bind method is called */
static int dm_test_bus_child_post_bind_uclass(struct unit_test_state *uts)
{
	struct dm_test_parent_platdata *plat;
	struct udevice *bus, *dev;
	int child_count;

	ut_assertok(uclass_get_device(UCLASS_TEST_BUS, 0, &bus));
	for (device_find_first_child(bus, &dev), child_count = 0;
	     dev;
	     device_find_next_child(&dev)) {
		/* Check that platform data is allocated */
		plat = dev_get_parent_platdata(dev);
		ut_assert(plat != NULL);
		ut_asserteq(2, plat->uclass_bind_flag);
		child_count++;
	}
	ut_asserteq(3, child_count);

	return 0;
}
DM_TEST(dm_test_bus_child_post_bind_uclass,
	DM_TESTF_SCAN_PDATA | DM_TESTF_SCAN_FDT);

/*
 * Test that the bus' uclass' child_pre_probe() is called before the
 * device's probe() method
 */
static int dm_test_bus_child_pre_probe_uclass(struct unit_test_state *uts)
{
	struct udevice *bus, *dev;
	int child_count;

	/*
	 * See testfdt_drv_probe() which effectively checks that the uclass
	 * flag is set before that method is called
	 */
	ut_assertok(uclass_get_device(UCLASS_TEST_BUS, 0, &bus));
	for (device_find_first_child(bus, &dev), child_count = 0;
	     dev;
	     device_find_next_child(&dev)) {
		struct dm_test_priv *priv = dev_get_priv(dev);

		/* Check that things happened in the right order */
		ut_asserteq_ptr(NULL, priv);
		ut_assertok(device_probe(dev));

		priv = dev_get_priv(dev);
		ut_assert(priv != NULL);
		ut_asserteq(1, priv->uclass_flag);
		ut_asserteq(1, priv->uclass_total);
		child_count++;
	}
	ut_asserteq(3, child_count);

	return 0;
}
DM_TEST(dm_test_bus_child_pre_probe_uclass,
	DM_TESTF_SCAN_PDATA | DM_TESTF_SCAN_FDT);
