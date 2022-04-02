/*
 * Copyright (C) 2022 Paranoid Android
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <endian.h>

#include <sys/file.h>
#include <sys/stat.h>

#define DT_TABLE_MAGIC 0xd7b7ab1e

struct dt_table_header {
    uint32_t magic;             // DT_TABLE_MAGIC
    uint32_t total_size;        // includes dt_table_header + all dt_table_entry
                                // and all dtb/dtbo
    uint32_t header_size;       // sizeof(dt_table_header)

    uint32_t dt_entry_size;     // sizeof(dt_table_entry)
    uint32_t dt_entry_count;    // number of dt_table_entry
    uint32_t dt_entries_offset; // offset to the first dt_table_entry
                                // from head of dt_table_header

    uint32_t page_size;         // flash page size we assume
    uint32_t version;       // DTBO image version, the current version is 0.
                            // The version will be incremented when the
                            // dt_table_header struct is updated.
};

struct dt_table_entry {
    uint32_t dt_size;
    uint32_t dt_offset;         // offset from head of dt_table_header

    uint32_t id;                // optional, must be zero if unused
    uint32_t rev;               // optional, must be zero if unused
    uint32_t custom[4];         // optional, must be zero if unused
};

struct fdt_header {
    uint32_t magic;
    uint32_t totalsize;
    uint32_t off_dt_struct;
    uint32_t off_dt_strings;
    uint32_t off_mem_rsvmap;
    uint32_t version;
    uint32_t last_comp_version;
    uint32_t boot_cpuid_phys;
    uint32_t size_dt_strings;
    uint32_t size_dt_struct;
};

int main(int argc, char **argv) {
    struct dt_table_header header;
    struct dt_table_entry entry;
    struct fdt_header *fdt_header;
    void *fdt;
    int fd = 0;
    int ret = 0;

    if (argv[1] == NULL || argv[2] == NULL) {
        return 1;
    }

    // Retrieved from stock dtbo
    header.magic = be32toh(DT_TABLE_MAGIC);
    header.header_size = be32toh(32);
    header.dt_entry_size = be32toh(32);
    header.dt_entry_count = be32toh(1);
    header.dt_entries_offset = be32toh(32);
    header.version = be32toh(0);
    header.page_size = be32toh(4096);

    fd = open(argv[1], O_RDONLY);
    if (fd < 0) {
        printf("Failed to open %s\n", argv[1]);
        return -1;
    }

    fdt_header = malloc(sizeof(*fdt_header));

    lseek(fd, 0, SEEK_SET);
    ret = read(fd, fdt_header, sizeof(*fdt_header));
    if (ret < 1) {
        printf("Failed to read %s\n", argv[1]);
        free(fdt_header);
        close(fd);
        return -1;
    }

    header.total_size = be32toh(64 + htobe32(fdt_header->totalsize));

    fdt = malloc(htobe32(fdt_header->totalsize));

    lseek(fd, 0, SEEK_SET);
    ret = read(fd, fdt, htobe32(fdt_header->totalsize));
    if (ret < 1) {
        printf("Failed to read %s\n", argv[1]);
        free(fdt_header);
        close(fd);
        return -1;
    }

    close(fd);

    int filesize = header.total_size;
    // Match page size
    if (filesize % 4096 != 0)
        filesize = ((filesize / 4096) + 1) * 4096;

    entry.dt_size = fdt_header->totalsize;
    entry.dt_offset = htobe32(64);
    entry.id = 0;
    entry.rev = 0;
    entry.custom[0] = 0;
    entry.custom[1] = 0;
    entry.custom[2] = 0;
    entry.custom[3] = 0;

    uint8_t *contents = malloc(filesize);
    memset(contents, 0, filesize);
    memcpy(contents, &header, 32);
    memcpy(contents + 32, &entry, 32);
    memcpy(contents + 64, fdt, htobe32(fdt_header->totalsize));
    
    fd = open(argv[2], O_WRONLY | O_CREAT, 0755);
    if (fd < 0) {
        printf("Failed to open %s\n", argv[2]);
        free(contents);
        free(fdt_header);
        free(fdt);
        return -1;
    }

    ret = write(fd, contents, filesize);
    if (ret < 1) {
        printf("Failed to write %s\n", argv[2]);
        free(contents);
        free(fdt);
        free(fdt_header);
        close(fd);
        return -1;
    }
    
    close(fd);
    free(contents);
    free(fdt);
    free(fdt_header);
    return 0;
}
