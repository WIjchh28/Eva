const fs = require("fs");
const path = require("path");

const FILE = path.join(__dirname, "memory.json");
const MAX = 8;
const store = new Map();

function load() {
  try {
    if (fs.existsSync(FILE)) {
      const data = JSON.parse(fs.readFileSync(FILE, "utf-8"));
      for (const [k, v] of Object.entries(data)) store.set(k, v);
    }
  } catch {}
}

function save() {
  fs.writeFileSync(FILE, JSON.stringify(Object.fromEntries(store), null, 2));
}

load();

module.exports = {
  get(id) {
    return [...(store.get(id) || [])];
  },
  append(id, role, content) {
    const list = store.get(id) || [];
    list.push({ role, content });
    if (list.length > MAX) list.splice(0, list.length - MAX);
    store.set(id, list);
    save();
  },
  clear(id) {
    store.delete(id);
    save();
  }
};
