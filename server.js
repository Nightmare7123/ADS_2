const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const cassandra = require("cassandra-driver");

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

// Cassandra (AstraDB) setup
const cassandraClient = new cassandra.Client({
  cloud: {
    secureConnectBundle: 'C:/Users/anupa/Anupam React/Angular JS/22510041_ADS_Assignment_9/Angular-Form/backend/secure-connect-22510041-db.zip',  
  },
  credentials: {
    username: 'kMTyqwpYJKOkRmTnHzpMtPaZ',
    password: 'uTEBiTTlw-3XwfUrrKbpkqay5Ao+K2JuJfOXHADTZPhZuUdorP+eF2JdNjS3HFhQP.+YSEftTc1IOkgLNp2xdHD6KHTWlUYqqiJFA2qib-9WaZPUs.zN-z5yyhLE6+Lh',
  },
  keyspace: '22510041',
});

cassandraClient.connect()
  .then(() => console.log("✅ Connected to Cassandra (AstraDB)"))
  .catch((err) => console.error("❌ Cassandra connection error:", err));

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

// Cassandra CRUD Routes
app.post("/cass-students", async (req, res) => {
  const { id, name, email, marks } = req.body;
  if (!id || !name || !email || marks == null) {
    return res.status(400).json({ error: "Missing required fields: id, name, email, marks" });
  }

  const query = 'INSERT INTO students (id, name, email, marks) VALUES (?, ?, ?, ?)';
  try {
    await cassandraClient.execute(query, [id, name, email, marks], { prepare: true });
    return res.status(201).json({ message: "Student inserted into Cassandra" });
  } catch (err) {
    console.error("❌ Cassandra insert error:", err);
    return res.status(500).json({ error: "Server error inserting into Cassandra" });
  }
});

app.get("/cass-students", async (req, res) => {
  const query = 'SELECT * FROM students';
  try {
    const result = await cassandraClient.execute(query);
    return res.status(200).json(result.rows);
  } catch (err) {
    console.error("❌ Error fetching students from Cassandra:", err);
    return res.status(500).json({ error: "Server error fetching students from Cassandra" });
  }
});

app.put("/cass-students/:id", async (req, res) => {
  const { id } = req.params;
  const { name, marks } = req.body;
  if (!name || marks == null) {
    return res.status(400).json({ error: "Missing fields for update" });
  }

  const query = 'UPDATE students SET name = ?, marks = ? WHERE id = ?';
  try {
    await cassandraClient.execute(query, [name, marks, id], { prepare: true });
    return res.status(200).json({ message: "Student updated in Cassandra" });
  } catch (err) {
    console.error("❌ Cassandra update error:", err);
    return res.status(500).json({ error: "Server error updating student in Cassandra" });
  }
});

app.delete("/cass-students/:id", async (req, res) => {
  const { id } = req.params;
  const query = 'DELETE FROM students WHERE id = ?';
  try {
    await cassandraClient.execute(query, [id], { prepare: true });
    return res.status(200).json({ message: "Student deleted from Cassandra", id });
  } catch (err) {
    console.error("❌ Cassandra delete error:", err);
    return res.status(500).json({ error: "Server error deleting student from Cassandra" });
  }
});

// Start the server
app.listen(port, () => console.log(`🚀 Server listening at http://localhost:${port}`));
