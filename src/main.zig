const std = @import("std");
const tk = @import("tokamak");

const routes: []const tk.Route = &.{
    .get("/", hello),
};

fn hello() ![]const u8 {
    return "Hello";
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();
    const port = 8080;

    var server = try tk.Server.init(allocator, routes, .{ .listen = .{ .port = port } });
    std.debug.print("Starting server on port {}...\n", .{port});
    try server.start();
}
