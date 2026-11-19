// MongoDB Model, Indexes, CRUD & Aggregation for LibraNet E-Resource Access Logs
use university_library_db;

// 1. Insert Sample E-Resource Access Document
db.user_activity_logs.insertOne({
  member_id: 1,
  department: "Data Science",
  resource_title: "Pattern Recognition Letters",
  categories: ["machine learning", "neural networks"],
  action: "download",
  e_resources_accessed: 4,
  engagement_time_minutes: 42.2,
  accessed_at: new Date("2026-11-12T10:20:00Z")
});

// 2. Create Indexes
db.user_activity_logs.createIndex({ member_id: 1, accessed_at: -1 });
db.user_activity_logs.createIndex({ department: 1, categories: 1 });

// 3. CRUD Operations
db.user_activity_logs.find({ department: "Data Science" });
db.user_activity_logs.updateOne({ member_id: 1 }, { $inc: { e_resources_accessed: 1 } });
db.user_activity_logs.deleteOne({ member_id: 9999 });

// 4. Aggregation Pipeline 1: Reader Engagement & Top E-Resources by Department
db.user_activity_logs.aggregate([
  { $match: { department: { $in: ["Computer Science", "Bioinformatics", "Data Science"] } } },
  {
    $group: {
      _id: "$department",
      total_e_resources_accessed: { $sum: "$e_resources_accessed" },
      avg_engagement_time: { $avg: "$engagement_time_minutes" },
      most_viewed_e_resource: { $first: "$resource_title" },
      active_users_count: { $sum: 1 }
    }
  },
  { $sort: { total_e_resources_accessed: -1 } }
]);

// 5. Aggregation Pipeline 2: Most Accessed Categories Across E-Resources
db.user_activity_logs.aggregate([
  { $unwind: "$categories" },
  { $group: { _id: "$categories", total_views: { $sum: "$e_resources_accessed" } } },
  { $sort: { total_views: -1 } }
]);
