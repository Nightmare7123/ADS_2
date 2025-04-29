const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const app = express();
const port = 3003;

app.use(cors());
app.use(express.json());

// Connect to MongoDB
mongoose
  .connect("mongodb://localhost:27017/StudentDB")
  .then(() => console.log("✅ Connected to MongoDB (StudentDB)"))
  .catch((err) => {
    console.error("❌ MongoDB connection error:", err);
    process.exit(1);
  });

// Schema & Model (MongoDB)
const studentSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  marks: { type: Number, required: true },
});
const Student = mongoose.model("Student", studentSchema);

// MongoDB CRUD Routes
app.post("/students", async (req, res) => {
  const { name, email, marks } = req.body;
  if (!name || !email || marks == null) {
    return res.status(400).json({ error: "Missing required fields: name, email, marks" });
  }

  try {
    const newStudent = new Student({ name, email, marks });
    const saved = await newStudent.save();
    return res.status(201).json(saved);
  } catch (err) {
    console.error("❌ Error inserting student:", err);
    if (err.code === 11000) {
      return res.status(409).json({ error: "Email already exists" });
    }
    return res.status(500).json({ error: "Server error inserting student" });
  }
});

app.get("/students", async (req, res) => {
  try {
    const list = await Student.find({});
    return res.status(200).json(list);
  } catch (err) {
    console.error("❌ Error fetching students:", err);
    return res.status(500).json({ error: "Server error fetching students" });
  }
});

app.put("/students/:id", async (req, res) => {
  const { id } = req.params;
  const { name, marks } = req.body;
  if (!name || marks == null) {
    return res.status(400).json({ error: "Missing fields for update" });
  }
  try {
    const updated = await Student.findByIdAndUpdate(
      id,
      { name, marks },
      { new: true, runValidators: true }
    );
    if (!updated) return res.status(404).json({ error: "Student not found" });
    return res.status(200).json(updated);
  } catch (err) {
    console.error("❌ Error updating student:", err);
    return res.status(500).json({ error: "Server error updating student" });
  }
});

app.delete("/students/:id", async (req, res) => {
  const { id } = req.params;
  try {
    const removed = await Student.findByIdAndDelete(id);
    if (!removed) return res.status(404).json({ error: "Student not found" });
    return res.status(200).json({ message: "Deleted", id });
  } catch (err) {
    console.error("❌ Error deleting student:", err);
    return res.status(500).json({ error: "Server error deleting student" });
  }
});

// Start the server
app.listen(port, () => console.log(`🚀 Server listening at http://localhost:${port}`));
