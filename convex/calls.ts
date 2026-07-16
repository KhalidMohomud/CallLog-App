import { mutation, query } from "./_generated/server";
import { v } from "convex/values";

/**
 * Save a single call record sent from the Flutter app.
 * Called by ConvexService.saveCall() via POST /api/mutation.
 */
export const saveCall = mutation({
  args: {
    phoneNumber: v.string(),
    callType: v.string(),
    duration: v.number(),
    startTime: v.string(),
    endTime: v.optional(v.string()),
    deviceId: v.string(),
    createdAt: v.string(),
  },
  handler: async (ctx, args) => {
    return await ctx.db.insert("calls", {
      phoneNumber: args.phoneNumber,
      callType: args.callType as "INCOMING" | "OUTGOING" | "MISSED",
      duration: args.duration,
      startTime: args.startTime,
      endTime: args.endTime,
      deviceId: args.deviceId,
      createdAt: args.createdAt,
    });
  },
});

/** List all calls for a given device (used by future CRM dashboard). */
export const listCallsByDevice = query({
  args: { deviceId: v.string() },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("calls")
      .withIndex("by_device", (q) => q.eq("deviceId", args.deviceId))
      .order("desc")
      .collect();
  },
});
