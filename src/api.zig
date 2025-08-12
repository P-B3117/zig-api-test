const std = @import("std");
const tk = @import("tokamak");

const gb = @import("./global.zig");
const res = @import("./ressource.zig");

const index = @embedFile("./html/index.html");

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

// To be known that specifying the allocator in the function parameters is necessary for memory management as that
// allocator frees everything after the requests ends. Somehow that doesn't work for the db.
pub const Api = struct {
    pub fn @"GET /"(response: *tk.Response) !void {
        response.header("Content-Type", "text/html");
        response.body = index;
        try response.write();
    }

    pub fn @"GET /components/:id"(allocator: std.mem.Allocator, id: u32) !res.Components {
        std.debug.print("component: {}\n", .{id});

        var db = try gb.app.dbPool.getSession(allocator);
        defer db.deinit();

        const req = try db.query(res.Components).find(id);
        if (req) |s| {
            // std.debug.print("component found: {}\n", .{s});
            // Clone the string data to prevent use-after-free
            return s;
        } else {
            return compErr;
        }
    }

    pub fn @"GET /components/"(allocator: std.mem.Allocator) ![]const res.Components {
        //std.debug.print("Listing all components\n", .{});
        var db = try gb.app.dbPool.getSession(allocator);
        defer db.deinit();

        // Create an ArrayList to hold Components values
        var ret = std.ArrayList(res.Components).init(allocator);
        // defer ret.deinit();

        for (try db.query(res.Components).findAll()) |req| {
            // Clone the string data to prevent use-after-free
            // const clone = try req.clone(allocator);
            try ret.append(req);
        }
        return ret.toOwnedSlice();
    }

    pub fn @"GET /troll"() res.Ans {
        std.debug.print("troll\n", .{});
        return .{ .id = 2, .title = "Troll", .body = "Hello" };
    }
};
