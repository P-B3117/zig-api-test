const std = @import("std");

const fr = @import("fridge");
const tk = @import("tokamak");

const gb = @import("./global.zig");
const initSql = @embedFile("./sql/init.sql");
const testSql = @embedFile("./sql/test_values.sql");

pub const App = struct {
    port: u16,
    dbSession: fr.Session,
    inProduction: bool = false,

    pub fn initDb(self: *App, allocator: std.mem.Allocator) !void {
        try self.getProduction();
        self.dbSession = try fr.Session.open(fr.SQLite3, allocator, .{ .filename = ":memory:" });

        try self.dbSession.exec(initSql, .{});
        if (!self.inProduction) {
            try self.dbSession.exec(testSql, .{});
        }

        const ans = try self.dbSession.insert(Ans, .{ .title = "allo", .body = "ça marche" });
        _ = try self.dbSession.insert(Ans, .{ .title = "allo2", .body = "ça marche mieux" });
        std.debug.print("Insert answer: {}\n", .{ans});
    }

    pub fn getProduction(self: *App) !void {
        const lol = std.posix.getenv("INVENTORUS_TEST"); // catch |err| switch (err) {
        //     error.EnvironmentVariableNotFound => self.inProduction = true,
        //     else => return err, // Re-throw other errors
        // };
        std.debug.print("{}  {}", .{ lol, self.inProduction });
    }
};

pub const Ans = struct {
    id: u32,
    title: []const u8,
    body: []const u8,
};

pub const Component = struct {
    id: u32,
    type_id: u32,
    value: []const u8,
    quantity: u32,
    footprint: []const u8,
    vendor_id: u32,
    description: []const u8,
    vendor_part_number: []const u8,
    price: u32,
};

pub const Vendor = struct {
    id: u32,
    url: []const u8,
    description: []const u8,
    name: []const u8,
};

pub const Type = struct {
    id: u32,
    name: []const u8,
    description: []const u8,
};
