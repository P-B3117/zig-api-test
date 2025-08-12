const std = @import("std");

const fr = @import("fridge");
const tk = @import("tokamak");

const gb = @import("./global.zig");
const initSql = @embedFile("./sql/init.sql");
const testSql = @embedFile("./sql/test_values.sql");

pub const App = struct {
    port: u16,
    dbPool: fr.Pool(fr.SQLite3),
    inProduction: bool = false,
    dbFileCreate: bool = false,
    dbPath: [:0]const u8 = "inventorusDb.sqlite",

    pub fn initDb(self: *App, allocator: std.mem.Allocator) !void {
        try self.getProduction();
        try self.getDbPath();
        self.dbPool = try fr.Pool(fr.SQLite3).init(allocator, .{ .max_count = 5 }, .{ .filename = self.dbPath });

        var db = try self.dbPool.getSession(allocator);
        defer db.deinit();

        try db.conn.execAll(initSql);
        if (!self.inProduction and self.dbFileCreate) {
            try db.conn.execAll(testSql);
        }
    }

    fn getProduction(self: *App) !void {
        const test_var: ?[]const u8 = std.posix.getenv("INVENTORUS_TEST");

        if (test_var) |_| {
            self.inProduction = false;
            std.debug.print("Test mode enabled\n", .{});
        } else {
            self.inProduction = true;
            std.debug.print("Production mode enabled\n", .{});
        }
    }

    fn getDbPath(self: *App) !void {
        _ = std.fs.cwd().statFile(self.dbPath) catch |err| switch (err) {
            error.FileNotFound => {
                std.debug.print("Path '{s}' does not exist.\n", .{self.dbPath});
                self.dbFileCreate = true;
                return;
            },
            else => {
                std.debug.print("Error checking db path\n", .{});
                return err;
            },
        };
    }
};

pub const Ans = struct {
    id: u32,
    title: []const u8,
    body: []const u8,
};

pub const Components = struct {
    id: u32,
    type_id: u32,
    value: []const u8,
    quantity: u32,
    footprint: []const u8,
    vendor_id: u32,
    description: []const u8,
    vendor_part_number: []const u8,
    price: []const u8, // gonna have to figure out how to handle this as a float
};

pub const Vendors = struct {
    id: u32,
    url: []const u8,
    description: []const u8,
    name: []const u8,
};

pub const Types = struct {
    id: u32,
    name: []const u8,
    description: []const u8,
};
