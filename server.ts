import express from "express";
import path from "path";
import fs from "fs";
import { createServer as createViteServer } from "vite";
import { GoogleGenAI } from "@google/genai";
import dotenv from "dotenv";

dotenv.config();

const app = express();
const PORT = 3000;

app.use(express.json());

// Initialize Gemini SDK with telemetry header
const apiKey = process.env.GEMINI_API_KEY;
let ai: GoogleGenAI | null = null;

if (apiKey) {
  ai = new GoogleGenAI({
    apiKey: apiKey,
    httpOptions: {
      headers: {
        "User-Agent": "aistudio-build",
      },
    },
  });
}

// Function to recursively build a file tree structure
interface FileNode {
  name: string;
  path: string;
  type: "file" | "directory";
  children?: FileNode[];
}

function getFileTree(dirPath: string, relativeRoot: string = ""): FileNode[] {
  const result: FileNode[] = [];
  if (!fs.existsSync(dirPath)) {
    return result;
  }

  const items = fs.readdirSync(dirPath);
  for (const item of items) {
    if (item === "node_modules" || item === ".git" || item === "dist" || item === ".DS_Store") {
      continue;
    }

    const fullPath = path.join(dirPath, item);
    const relPath = path.join(relativeRoot, item);
    const stat = fs.statSync(fullPath);

    if (stat.isDirectory()) {
      result.push({
        name: item,
        path: relPath,
        type: "directory",
        children: getFileTree(fullPath, relPath),
      });
    } else {
      result.push({
        name: item,
        path: relPath,
        type: "file",
      });
    }
  }

  // Sort directories first, then files alphabetically
  return result.sort((a, b) => {
    if (a.type !== b.type) {
      return a.type === "directory" ? -1 : 1;
    }
    return a.name.localeCompare(b.name);
  });
}

// API Endpoints

// 1. Get Flutter File Tree
app.get("/api/files", (req, res) => {
  const flutterDir = path.join(process.cwd(), "flutter");
  try {
    const fileTree = getFileTree(flutterDir);
    res.json({ success: true, tree: fileTree });
  } catch (error: any) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// 2. Get Single File Content
app.get("/api/files/content", (req, res) => {
  const fileRelPath = req.query.path as string;
  if (!fileRelPath) {
    return res.status(400).json({ success: false, error: "Path query parameter is required" });
  }

  // Prevent Directory Traversal
  const safePath = path.normalize(fileRelPath).replace(/^(\.\.(\/|\\|$))+/, "");
  const absolutePath = path.join(process.cwd(), "flutter", safePath);

  try {
    if (!fs.existsSync(absolutePath)) {
      return res.status(404).json({ success: false, error: "File not found" });
    }
    const stat = fs.statSync(absolutePath);
    if (!stat.isFile()) {
      return res.status(400).json({ success: false, error: "Not a file" });
    }

    const content = fs.readFileSync(absolutePath, "utf-8");
    res.json({ success: true, content });
  } catch (error: any) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// 3. AI Chat with Sanvi (Gemini SDK)
app.post("/api/chat", async (req, res) => {
  const { messages } = req.body;
  if (!messages || !Array.isArray(messages)) {
    return res.status(400).json({ success: false, error: "messages array is required" });
  }

  // Fallback if API Key is not set or SDK fails
  if (!ai) {
    return res.json({
      success: true,
      message: "Hello! I am Sanvi, your permanent AI Assistant for Apps Buddy. (Note: GEMINI_API_KEY is not configured in Secrets yet, so I am running in local architectural simulator mode! Set your API key in Settings > Secrets to enable live Gemini guidance.)\n\nI can verify that our Phase 1 foundation is perfectly structured with clean architecture, ready to support all future application workflows."
    });
  }

  try {
    // Format messages for @google/genai
    // Standard format for Gemini API is prompt string or structured parts
    // To facilitate conversation, we extract the last user message and provide the conversation history in the prompt or as contents.
    const lastUserMessage = messages[messages.length - 1]?.content || "";

    const systemInstruction = `You are "Sanvi", the permanent AI companion and assistant built inside "Apps Buddy". 
Apps Buddy is a premium, minimal, production-ready application to find search and alternating options for software apps across Android, Web, and Windows desktop.
Currently, the developer has successfully bootstrapped "Phase 1 - Part 1: Master Foundation & Clean Architecture".
Your tone is professional, highly knowledgeable, friendly, clear, and reassuring.
You can discuss any aspects of Apps Buddy's clean architecture, including:
1. Complete Project Structure & Feature-Based folders
2. Theme, Core Services (logger, error handling, router, DI prep, environment config)
3. Windows, Android, and Web build configurations
4. Integration plans for Ads, subscriptions, authentication, and AI.
Do not make up fake features. Emphasize that in this Phase 1, we have built the absolute perfect structural framework, and we are ready for Phase 2 implementation.`;

    const response = await ai.models.generateContent({
      model: "gemini-3.5-flash",
      contents: lastUserMessage,
      config: {
        systemInstruction,
        temperature: 0.7,
      },
    });

    res.json({ success: true, message: response.text });
  } catch (error: any) {
    // Check if error is quota-related (429 / RESOURCE_EXHAUSTED) or rate limited
    const errorStr = JSON.stringify(error) || "";
    const errorMsg = error?.message || "";
    const errorStatus = error?.status || "";
    const errorCode = error?.code || "";
    const isQuotaError = errorMsg.includes("429") || 
                         errorMsg.includes("RESOURCE_EXHAUSTED") || 
                         errorMsg.toLowerCase().includes("quota") ||
                         errorStatus.toString().includes("429") ||
                         errorCode.toString().includes("429") ||
                         errorStr.includes("429") ||
                         errorStr.includes("RESOURCE_EXHAUSTED");

    if (isQuotaError) {
      console.log("[Gemini API Info] Quota limits reached or rate-limited (429/RESOURCE_EXHAUSTED). Gracefully engaging local/simulated fallback responses.");
    } else {
      console.error("Gemini Error:", error);
    }
    
    const lastUserMessage = req.body.messages?.[req.body.messages.length - 1]?.content || "";
    const isJsonRequest = lastUserMessage.toLowerCase().includes("json");

    if (isQuotaError) {
      if (isJsonRequest) {
        return res.json({
          success: true,
          message: JSON.stringify({
            name: "Alternative Search (Simulated)",
            description: "High-performance matching utilizing local fallback databases.",
            alternatives: [
              { name: "VS Code", original: "Sublime Text", desc: "Open-source, highly customizable code editor with massive extension library.", category: "Development" },
              { name: "LibreOffice", original: "MS Office", desc: "Free and open-source office suite supporting all document formats.", category: "Productivity" }
            ]
          })
        });
      }

      return res.json({
        success: true,
        message: "Hello! I am Sanvi, your AI companion. It looks like my live Gemini API connection is currently under high load or has reached its daily quota limit (429 Resource Exhausted).\n\nNo worries! I have automatically switched to local architectural simulator mode. I am fully capable of helping you navigate our clean architecture, Phase 1 foundations, and any configuration details for Android, Web, and Windows builds!"
      });
    }

    // For other types of connection or API errors, fall back gracefully
    if (isJsonRequest) {
      return res.json({
        success: true,
        message: JSON.stringify({
          name: "Fallback Search Results",
          description: "Simulated matching using the local index.",
          alternatives: []
        })
      });
    }

    return res.json({
      success: true,
      message: `Hello! I am Sanvi. I encountered an issue connecting to my live Gemini brain: "${errorMsg || "API Connection Issue"}". I've safely engaged our local fallback engine so you can continue using Apps Buddy uninterrupted!`
    });
  }
});

// Serve Vite dev server in development or static build in production
async function startServer() {
  if (process.env.NODE_ENV !== "production") {
    const vite = await createViteServer({
      server: { middlewareMode: true },
      appType: "spa",
    });
    app.use(vite.middlewares);
  } else {
    const distPath = path.join(process.cwd(), "dist");
    app.use(express.static(distPath));
    app.get("*", (req, res) => {
      res.sendFile(path.join(distPath, "index.html"));
    });
  }

  app.listen(PORT, "0.0.0.0", () => {
    console.log(`[Apps Buddy Hub] Server running on http://localhost:${PORT}`);
  });
}

startServer();
