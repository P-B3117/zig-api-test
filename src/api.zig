const std = @import("std");

const gb = @import("./global.zig");
const res = @import("./ressource.zig");

const compErr = res.Components{
    .id = 0,
    .type_id = 0,
    .value = "",
    .quantity = 0,
    .footprint = "",
    .vendor_id = 0,
    .description = "",
    .vendor_part_number = "",
    .price = "",
};

pub const Api = struct {
    pub fn @"GET /"() ![]const u8 {
        return "Hello";
    }

    pub fn @"GET /components/:id"(id: u32) !res.Components {
        std.debug.print("component: {}\n", .{id});

        const allocator = std.heap.page_allocator;
        var db = try gb.app.dbPool.getSession(allocator);
        defer db.deinit();

        const req = try db.query(res.Components).find(id);
        if (req) |s| {
            // std.debug.print("component found: {}\n", .{s});
            return s;
        } else {
            return compErr;
        }
    }

    pub fn @"GET /components/"() ![]const res.Components {
        //std.debug.print("Listing all components\n", .{});
        const allocator = std.heap.page_allocator;
        var db = try gb.app.dbPool.getSession(allocator);
        defer db.deinit();

        // Create an ArrayList to hold Components values
        var ret = std.ArrayList(res.Components).init(allocator);
        defer ret.deinit();

        for (try db.query(res.Components).findAll()) |req| {
            try ret.append(req);
        }
        return ret.toOwnedSlice();
    }

    pub fn @"GET /troll"() res.Ans {
        std.debug.print("troll\n", .{});
        return .{ .id = 2, .title = "Troll", .body = "Hello" };
    }
};
