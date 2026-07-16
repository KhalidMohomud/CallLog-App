import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

/**
 * Beecbile Call Tracker - Convex database schema.
 *
 * Deploy with:  npx convex deploy
 * Local dev:    npx convex dev
 */
export default defineSchema({
  calls: defineTable({
    phoneNumber: v.string(),
    callType: v.union(
      v.literal("INCOMING"),
      v.literal("OUTGOING"),
      v.literal("MISSED"),
    ),
    duration: v.number(),
    startTime: v.string(),
    endTime: v.optional(v.string()),
    deviceId: v.string(),
    createdAt: v.string(),
  })
    .index("by_device", ["deviceId"])
    .index("by_created_at", ["createdAt"]),
});
