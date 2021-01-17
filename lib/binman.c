// SPDX-License-Identifier: Intel
/*
 * Access to binman information at runtime
 *
 * Copyright 2019 Google LLC
 * Written by Simon Glass <sjg@chromium.org>
 */

#include <common.h>
#include <binman.h>
#include <dm.h>
#include <log.h>
#include <malloc.h>
#include <mapmem.h>

/**
 * struct binman_info - Information needed by the binman library
 *
 * @image: Node describing the image we are running from
 * @rom_offset: Offset from an image_pos to the memory-mapped address, or
 *	ROM_OFFSET_NONE if the ROM is not memory-mapped. Can be positive or
 *	negative
 */
struct binman_info {
	ofnode image;
	int rom_offset;
};

#define ROM_OFFSET_NONE		(-1)

static struct binman_info *binman;

static int binman_entry_find_internal(ofnode node, const char *name,
				      struct binman_entry *entry)
{
	int ret;

	if (!ofnode_valid(node))
		node = binman->image;
	node = ofnode_find_subnode(node, name);
	if (!ofnode_valid(node))
		return log_msg_ret("node", -ENOENT);

	ret = ofnode_read_u32(node, "image-pos", &entry->image_pos);
	if (ret)
		return log_msg_ret("image-pos", ret);
	ret = ofnode_read_u32(node, "size", &entry->size);
	if (ret)
		return log_msg_ret("size", ret);

	return 0;
}

int binman_entry_find(const char *name, struct binman_entry *entry)
{
	return binman_entry_find_internal(binman->image, name, entry);
}

int binman_entry_map(ofnode parent, const char *name, void **bufp, int *sizep)
{
	struct binman_entry entry;
	int ret;

	if (binman->rom_offset == ROM_OFFSET_NONE)
		return -EPERM;
	ret = binman_entry_find_internal(parent, name, &entry);
	if (ret)
		return log_msg_ret("entry", ret);
	if (sizep)
		*sizep = entry.size;
	*bufp = map_sysmem(entry.image_pos + binman->rom_offset, entry.size);

	return 0;
}

ofnode binman_section_find_node(const char *name)
{
	return ofnode_find_subnode(binman->image, name);
}

void binman_set_rom_offset(int rom_offset)
{
	binman->rom_offset = rom_offset;
}

int binman_get_rom_offset(void)
{
	return binman->rom_offset;
}

int binman_init(void)
{
	binman = malloc(sizeof(struct binman_info));
	if (!binman)
		return log_msg_ret("space for binman", -ENOMEM);
	binman->image = ofnode_path("/binman");
	if (!ofnode_valid(binman->image))
		return log_msg_ret("binman node", -EINVAL);
	if (ofnode_read_bool(binman->image, "multiple-images")) {
		ofnode node = ofnode_first_subnode(binman->image);

		if (!ofnode_valid(node))
			return log_msg_ret("first image", -ENOENT);
		binman->image = node;
	}
	binman_set_rom_offset(ROM_OFFSET_NONE);

	return 0;
}
