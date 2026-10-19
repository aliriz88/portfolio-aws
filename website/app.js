// Calls the visitor counter API and shows the result.
// window.API_URL comes from config.js, which Terraform generates.
async function updateCounter() {
  const el = document.getElementById("visitor-count");

  if (!window.API_URL) {
    el.textContent = "coming soon";
    return;
  }

  try {
    const res = await fetch(window.API_URL, { method: "POST" });
    if (!res.ok) throw new Error(`API returned ${res.status}`);
    const data = await res.json();
    el.textContent = data.count;
  } catch (err) {
    el.textContent = "unavailable";
    console.error(err);
  }
}

updateCounter();
