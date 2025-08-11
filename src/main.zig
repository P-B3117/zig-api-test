const std = @import("std");
const res = @import("./ressource.zig");
const gb = @import("./global.zig");
const api = @import("./api.zig");

const fr = @import("fridge");
const tk = @import("tokamak");

const routes: []const tk.Route = &.{
    // tk.logger(.{}),
    .get("/test", tk.send("Hello")), // Classic Express-style routing
    .group("/", &.{.router(api.Api)}), // Structured routing with a module
    .send(error.NotFound),
};

pub fn main() !void {
    // generating memory allocator for db
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    // initializing db
    std.debug.print("initializing db\n", .{});
    try gb.app.initDb(allocator);
    defer gb.app.dbSession.deinit();

    // var inj = tk.Injector.init(&.{.ref(gb.app)}, null);

    var server = try tk.Server.init(allocator, routes, .{
        // .injector = &inj,
        .listen = .{ .port = gb.app.port },
    });

    std.debug.print("Starting server on port {}...\n", .{gb.app.port});
    try server.start();
}
