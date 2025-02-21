const express = require("express");
const path = require("path");
const supabase = require("./db");
const app = express();
const PORT = 3000;

// Middleware to parse JSON bodies
app.use(express.json());

// Serve static files from the "frontend" directory
app.use(express.static(path.join(__dirname, "frontend")));

// Root route to serve index.html
app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname, "frontend", "index.html"));
});

// Signup route
app.post("/signup", async (req, res) => {
    const { name, email, password, role } = req.body;

    // Insert new user into the database
    const { data, error } = await supabase
        .from("users")
        .insert([{ name, email, password, role }]);

    if (error) {
        return res.status(500).json({ error: error.message });
    }
    res.json({ message: "Signup successful!", user: data });
});

// Login route
app.post("/login", async (req, res) => {
    const { email, password, role } = req.body;

    // Fetch user from the database
    const { data, error } = await supabase
        .from("users")
        .select("*")
        .eq("email", email)
        .eq("password", password)
        .eq("role", role)
        .single();

    if (error || !data) {
        return res.status(401).json({ error: "Invalid credentials" });
    }
    res.json({ message: "Login successful!", user: data });
});

// Fetch menu suggestions based on community
app.get("/menu", async (req, res) => {
    const { community } = req.query;

    // Fetch menu items from the database
    const { data, error } = await supabase
        .from("menus")
        .select("*")
        .eq("community", community);

    if (error) {
        return res.status(500).json({ error: error.message });
    }
    res.json(data);
});

// Fetch ingredient list based on guest count
app.get("/ingredients", async (req, res) => {
    const { guests } = req.query;

    // Fetch ingredients from the database
    const { data, error } = await supabase
        .from("ingredients")
        .select("*")
        .gte("min_guests", guests)
        .lte("max_guests", guests);

    if (error) {
        return res.status(500).json({ error: error.message });
    }
    res.json(data);
});

// Fetch estimated cost based on guest count
app.get("/cost", async (req, res) => {
    const { guests } = req.query;

    // Fetch cost from the database
    const { data, error } = await supabase
        .from("costs")
        .select("*")
        .eq("guest_count", guests);

    if (error) {
        return res.status(500).json({ error: error.message });
    }
    res.json(data[0]);
});

// Get detailed quote
app.post("/quote", async (req, res) => {
    const { community, guestCount } = req.body;

    // Insert quote into the database
    const { data, error } = await supabase
        .from("quotes")
        .insert([{ community, guest_count: guestCount }]);

    if (error) {
        return res.status(500).json({ error: error.message });
    }
    res.json(data[0]);
});


// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});


// Fetch all items for a vendor
app.get("/items", async (req, res) => {
    const { vendor_id } = req.query;

    const { data, error } = await supabase
        .from("items")
        .select("*")
        .eq("vendor_id", vendor_id);

    if (error) {
        return res.status(500).json({ error: error.message });
    }
    res.json(data);
});

// Add a new item
app.post("/items", async (req, res) => {
    const { name, price, availability, vendor_id } = req.body;

    const { data, error } = await supabase
        .from("items")
        .insert([{ name, price, availability, vendor_id }])
        .select(); // Add .select() to return the inserted data

    if (error) {
        return res.status(500).json({ error: error.message });
    }
    res.json(data[0]); // Return the newly added item
});

// Delete an item
app.delete("/items/:id", async (req, res) => {
    const { id } = req.params;

    const { data, error } = await supabase
        .from("items")
        .delete()
        .eq("id", id);

    if (error) {
        return res.status(500).json({ error: error.message });
    }
    res.json({ message: "Item deleted successfully" });
});