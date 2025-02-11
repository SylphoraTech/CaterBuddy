document.addEventListener("DOMContentLoaded", function () {
    console.log("Documentation page loaded");

    const info = [
        "This server is built with Express.js",
        "It serves static files from the 'frontend' directory",
        "The root route '/' serves index.html",
        "It runs on port 3000"
    ];

    console.log("Key Points:");
    info.forEach(point => console.log("- " + point));
});
