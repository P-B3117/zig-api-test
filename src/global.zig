const res = @import("./ressource.zig");

pub var app = res.App{
    .port = 8080,
    .dbSession = undefined,
    .inProduction = false,
};
