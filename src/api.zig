const std = @import("std");
const gb = @import("./global.zig");
const res = @import("./ressource.zig");

pub const Api = struct {
    pub fn @"GET /"() ![]const u8 {
        std.debug.print("Ans Table:\n", .{});

        for (try gb.app.dbSession.query(res.Ans).findAll()) |ans| {
            std.debug.print("Ans: {}, {s}, {s}\n", .{ ans.id, ans.title, ans.body });
        }

        return "Hello";
    }

    pub fn @"GET /miam/:id"(id: u32) !res.Ans {
        std.debug.print("miam: {}\n", .{id});
        const req = try gb.app.dbSession.query(res.Ans).find(id);
        if (req) |s| {
            return .{ .id = s.id, .title = s.title, .body = s.body };
        } else {
            return .{ .id = 0, .title = "error", .body = "error" };
        }
    }

    pub fn @"GET /miam/"() ![]const res.Ans {
        std.debug.print("miam\n", .{});
        const allocator = std.heap.page_allocator;

        // Create an ArrayList to hold Ans values
        var ret = std.ArrayList(res.Ans).init(allocator);
        defer ret.deinit();

        for (try gb.app.dbSession.query(res.Ans).findAll()) |req| {
            std.debug.print("req: {} {s} {s}\n", .{ req.id, req.title, req.body });
            try ret.append(req);
        }
        return ret.toOwnedSlice();
    }

    pub fn @"GET /troll"() res.Ans {
        std.debug.print("troll\n", .{});
        return .{ .id = 2, .title = "Troll", .body = "Hello" };
    }
};
