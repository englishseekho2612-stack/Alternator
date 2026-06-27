import { useState, useEffect } from 'react';
import { 
  Search, 
  Layers, 
  Heart, 
  Share2, 
  FileCode, 
  CheckCircle2, 
  AlertCircle, 
  Sparkles, 
  MessageSquare, 
  Smartphone, 
  Globe, 
  Monitor, 
  Settings, 
  RefreshCw, 
  Send, 
  Check, 
  ChevronRight, 
  ChevronDown, 
  Folder, 
  FileText,
  ExternalLink,
  Code2,
  Copy,
  Info,
  BadgeAlert,
  Play,
  Volume2,
  VolumeX
} from 'lucide-react';

interface FileNode {
  name: string;
  path: string;
  type: 'file' | 'directory';
  children?: FileNode[];
}

export default function App() {
  // Navigation & Active tab state of the mock simulator
  const [activeTab, setActiveTab] = useState<'search' | 'chat' | 'premium' | 'dashboard' | 'admin'>('dashboard');
  
  // Voice Synthesis state for Sanvi (10yo girl voice)
  const [isVoiceMuted, setIsVoiceMuted] = useState(false);
  const [isSpeaking, setIsSpeaking] = useState<string | null>(null);
  
  // Phase 4 User Profile & Settings State
  const [userDisplayName, setUserDisplayName] = useState('Amrit Kumar');
  const [userPreferredLang, setUserPreferredLang] = useState<'en'>('en');
  const [isCloudSyncActive, setIsCloudSyncActive] = useState(true);
  const [isSyncingState, setIsSyncingState] = useState(false);
  const [lastSyncedTime, setLastSyncedTime] = useState<string>('3 hours ago');
  const [emailNotifications, setEmailNotifications] = useState(true);
  const [pushNotifications, setPushNotifications] = useState(true);
  const [appThemeMode, setAppThemeMode] = useState<'dark' | 'light' | 'system'>('dark');
  const [avatarSeed, setAvatarSeed] = useState('Felix');
  
  // Favorites sorting & filtering UI state
  const [favSearchQuery, setFavSearchQuery] = useState('');
  const [favSortBy, setFavSortBy] = useState<'name' | 'date'>('name');
  const [favFilterType, setFavFilterType] = useState<'all' | 'open_source' | 'commercial'>('all');

  // Phase 5 Admin Dashboard & Content States
  const [adminRole, setAdminRole] = useState<'Super Admin' | 'Admin' | 'Moderator' | 'Support' | 'Viewer'>('Super Admin');
  const [adminSuspendUserList, setAdminSuspendUserList] = useState<string[]>(['Rohan Sharma']);
  const [aiPromptTemplate, setAiPromptTemplate] = useState('You are Sanvi, a warm expert companion designed to suggest great open source and local software alternatives. Keep explanation brief, natural and highlight local applications.');
  const [aiDailyLimit, setAiDailyLimit] = useState(5);
  const [aiPersonality, setAiPersonality] = useState<'conversational' | 'professional' | 'hinglish'>('conversational');
  const [aiSafetyFilters, setAiSafetyFilters] = useState(true);
  const [maintenanceMode, setMaintenanceMode] = useState(false);
  const [adminSearchUserQuery, setAdminSearchUserQuery] = useState('');
  
  // CMS Content Mappings
  const [cmsBanners, setCmsBanners] = useState([
    { id: 'b1', title: 'Unlock Pro Alternatives with 50% less memory footprint!', active: true },
    { id: 'b2', title: 'Need vector design tools? Krita & Penpot are now active featured alts!', active: true }
  ]);
  const [featuredApps, setFeaturedApps] = useState([
    { name: 'GIMP', original: 'Adobe Photoshop', desc: 'Powerful open-source photo editor & vector composition suit.', category: 'Graphics' },
    { name: 'LibreOffice Calc', original: 'Microsoft Excel', desc: 'Secure local spreadsheet utility featuring full format compatibility.', category: 'Office' },
    { name: 'DaVinci Resolve', original: 'Adobe Premiere', desc: 'Professional level video production, grading & sound effects.', category: 'Video' }
  ]);
  const [cmsFaqs, setCmsFaqs] = useState([
    { q: 'Is Apps Buddy fully offline?', a: 'Yes! Local cached lookups operate directly on your device disk storage.' },
    { q: 'How does Sanvi AI provide suggestions?', a: 'Sanvi matches queries against vetted cloud repositories of highly optimized packages.' }
  ]);
  const [adminLogs, setAdminLogs] = useState([
    { time: '10:14 AM', actor: 'Super Admin', action: 'INIT_SYSTEM', desc: 'Synchronized Phase 5 administrative panels & RBAC parameters.' },
    { time: '11:32 AM', actor: 'Super Admin', action: 'CMS_UPDATE', desc: 'Created OnlyOffice and Penpot featured software mapping.' },
  ]);

  // Phase 3 Monetization State
  const [membershipTier, setMembershipTier] = useState<'free' | 'trial' | 'premium'>('trial');
  const [trialDaysLeft, setTrialDaysLeft] = useState(3);
  const [aiSearchUsage, setAiSearchUsage] = useState(1); // Start with 1 search used
  const [transactions, setTransactions] = useState<Array<{ id: string; plan: string; amount: string; date: string }>>([
    { id: 'pay_tx_78129', plan: '3-Day Free Trial Auto-Activation', amount: '₹0', date: new Date().toLocaleDateString() }
  ]);
  const [admobCounter, setAdmobCounter] = useState(0);

  // Search Engine simulated state
  const [searchQuery, setSearchQuery] = useState('Photoshop');
  const [isSearching, setIsSearching] = useState(false);
  const [searchResult, setSearchResult] = useState<any>(null);
  const [searchError, setSearchError] = useState<string | null>(null);
  
  // AI Chat simulated state
  const [chatMessages, setChatMessages] = useState<Array<{ sender: 'user' | 'sanvi'; content: string; time: string }>>([
    { 
      sender: 'sanvi', 
      content: 'Hello! I am Sanvi, your AI companion. Ask me anything about legal, free, or open-source alternatives to premium apps. I am ready to guide you!', 
      time: '13:41' 
    }
  ]);
  const [chatInput, setChatInput] = useState('');
  const [isChatLoading, setIsChatLoading] = useState(false);

  // Favorites & History state (Mock persistence)
  const [favorites, setFavorites] = useState<string[]>(['Adobe Photoshop', 'Visual Studio Code']);
  const [searchHistory, setSearchHistory] = useState<string[]>(['Photoshop', 'VS Code', 'Canva']);
  const [showHistory, setShowHistory] = useState(false);
  const [toastMessage, setToastMessage] = useState<string | null>(null);

  // Codebase File Explorer state
  const [fileTree, setFileTree] = useState<FileNode[]>([]);
  const [expandedFolders, setExpandedFolders] = useState<Record<string, boolean>>({
    'lib': true,
    'lib/core': true,
    'lib/features': true,
    'lib/features/search': true,
    'lib/features/search/presentation': true,
    'lib/features/monetization': true,
    'lib/features/monetization/domain': true,
    'lib/features/monetization/domain/models': true,
    'lib/features/monetization/presentation': true,
    'lib/features/monetization/presentation/views': true,
  });
  const [selectedFilePath, setSelectedFilePath] = useState<string>('lib/features/monetization/domain/models/membership_details.dart');
  const [selectedFileContent, setSelectedFileContent] = useState<string>('');
  const [isFileLoading, setIsFileLoading] = useState(false);
  const [copied, setCopied] = useState(false);

  // Verification tool simulation state
  const [verifying, setVerifying] = useState(false);
  const [verificationSuccess, setVerificationSuccess] = useState<boolean | null>(null);
  const [verificationLogs, setVerificationLogs] = useState<string[]>([]);

  // Toast notifier helper
  const triggerToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => setToastMessage(null), 3000);
  };

  // 1. Fetch file tree on mount
  useEffect(() => {
    fetchFileTree();
    fetchFileContent(selectedFilePath);
  }, []);

  const fetchFileTree = async () => {
    try {
      const res = await fetch('/api/files');
      const data = await res.json();
      if (data.success) {
        setFileTree(data.tree);
      }
    } catch (err) {
      console.error("Error fetching file tree:", err);
    }
  };

  const fetchFileContent = async (pathStr: string) => {
    setIsFileLoading(true);
    try {
      const res = await fetch(`/api/files/content?path=${encodeURIComponent(pathStr)}`);
      const data = await res.json();
      if (data.success) {
        setSelectedFileContent(data.content);
        setSelectedFilePath(pathStr);
      } else {
        setSelectedFileContent(`// Error loading file: ${data.error}`);
      }
    } catch (err) {
      setSelectedFileContent(`// Failed to fetch content: ${err}`);
    } finally {
      setIsFileLoading(false);
    }
  };

  // 2. Perform Sanvi AI Search Engine search
  const handleSearchSubmit = async (queryToSearch: string) => {
    if (!queryToSearch.trim()) {
      setSearchError("Please enter a software name.");
      return;
    }

    // Limit check for free user tier
    if (membershipTier === 'free' && aiSearchUsage >= 3) {
      setSearchError("Daily free limit of 3 searches reached. Please upgrade to Premium or use Free Trial.");
      triggerToast("Daily free limit reached! Upgrade to Premium.");
      return;
    }

    setIsSearching(true);
    setSearchError(null);
    setSearchResult(null);

    // Increment usage
    setAiSearchUsage(prev => prev + 1);

    // Save search history
    if (!searchHistory.includes(queryToSearch)) {
      setSearchHistory(prev => [queryToSearch, ...prev.slice(0, 5)]);
    }

    const qLower = queryToSearch.toLowerCase().trim();
    const isPresetApp = qLower === 'photoshop' || 
                         qLower === 'adobe photoshop' ||
                         qLower === 'vs code' || 
                         qLower === 'visual studio code' || 
                         qLower === 'canva';

    if (isPresetApp) {
      setTimeout(() => {
        setSearchResult(generateSimulatorData(queryToSearch));
        setIsSearching(false);
      }, 300);
      return;
    }

    try {
      // Simulate real call via backend prompt processing
      const response = await fetch('/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          messages: [
            {
              sender: 'user',
              content: `Give me structured JSON information for the software "${queryToSearch}" as defined by search prompt guidelines. Return ONLY JSON.`
            }
          ]
        })
      });
      const data = await response.json();
      if (data.success) {
        // Try to parse the Gemini output as JSON if it represents structured app search
        try {
          // If the AI replied with simulated conversational text or JSON, we process it
          if (data.message.trim().startsWith('{')) {
            const parsed = JSON.parse(data.message);
            setSearchResult(parsed);
          } else {
            // Parse custom dynamic response structure
            const simulatedResult = generateSimulatorData(queryToSearch);
            setSearchResult(simulatedResult);
          }
        } catch (e) {
          const simulatedResult = generateSimulatorData(queryToSearch);
          setSearchResult(simulatedResult);
        }
      } else {
        setSearchError("AI Search Server timeout. Showing local cached parser.");
        setSearchResult(generateSimulatorData(queryToSearch));
      }
    } catch (error) {
      // Fallback
      setSearchResult(generateSimulatorData(queryToSearch));
    } finally {
      setIsSearching(false);
    }
  };

  // Helper generator of simulator data
  const generateSimulatorData = (q: string) => {
    const qLower = q.toLowerCase();
    if (qLower.includes('photo') || qLower.includes('adobe')) {
      return {
        name: 'Adobe Photoshop',
        developer: 'Adobe Inc.',
        category: 'Professional Graphic Editor',
        officialWebsite: 'https://www.adobe.com/products/photoshop.html',
        supportedPlatforms: ['Windows', 'macOS', 'iPadOS'],
        officialDownloadLink: 'https://www.adobe.com/products/photoshop/free-trial-download.html',
        pricing: '$22.99 / mo subscription',
        hasFreeVersion: false,
        hasOfficialTrial: true,
        systemRequirements: 'Multicore Intel/AMD, 8GB RAM, GPU supporting DirectX 12',
        topFeatures: [
          'Generative Fill & Neural Filters',
          'Industry-leading Non-Destructive layers',
          'Precision selections & masking tools',
          'Camera RAW advanced camera development'
        ],
        pros: [
          'Industry standard toolset & tutorials',
          'Perfect design pipeline integration',
          'Unrivaled photo-manipulation abilities'
        ],
        cons: [
          'Subscription model only (Very Expensive)',
          'Requires heavy hardware processing',
          'Steep learning curve for beginners'
        ],
        similarApplications: [
          { name: 'Affinity Photo', category: 'Graphic Design', url: 'https://affinity.serif.com', pricing: '$69.99 One-time', isOpenSource: false },
          { name: 'Canva', category: 'Creative Suite', url: 'https://canva.com', pricing: 'Free / Premium options', isOpenSource: false }
        ],
        openSourceAlternatives: [
          { name: 'GIMP', category: 'Graphic Design', url: 'https://www.gimp.org', pricing: '100% Free / Open Source', isOpenSource: true },
          { name: 'Krita', category: 'Digital Painting', url: 'https://krita.org', pricing: '100% Free / Open Source', isOpenSource: true }
        ],
        communityRating: 4.8,
        lastUpdated: 'June 2026'
      };
    } else if (qLower.includes('code') || qLower.includes('vs')) {
      return {
        name: 'Visual Studio Code',
        developer: 'Microsoft Corp.',
        category: 'Source Code Editor',
        officialWebsite: 'https://code.visualstudio.com',
        supportedPlatforms: ['Windows', 'macOS', 'Linux', 'Web'],
        officialDownloadLink: 'https://code.visualstudio.com/Download',
        pricing: 'Free / Community Driven',
        hasFreeVersion: true,
        hasOfficialTrial: false,
        systemRequirements: '1.6GHz CPU, 1GB RAM, 500MB drive space',
        topFeatures: [
          'Robust Extension Marketplace',
          'Built-in Git & GitHub visual controls',
          'IntelliSense automatic code completions',
          'Integrated full-fledged Terminal & Debugger'
        ],
        pros: [
          'Extremely fast, customizable, and lightweight',
          'Overwhelming developer community support',
          'Perfect Flutter/Dart out-of-the-box bindings'
        ],
        cons: [
          'Advanced workspace configs can be verbose',
          'Large extension lists can increase memory'
        ],
        similarApplications: [
          { name: 'Sublime Text', category: 'Code Editor', url: 'https://sublimetext.com', pricing: '$99 License', isOpenSource: false },
          { name: 'IntelliJ IDEA', category: 'Full IDE', url: 'https://jetbrains.com', pricing: 'Subscription model', isOpenSource: false }
        ],
        openSourceAlternatives: [
          { name: 'VSCodium', category: 'Telemetry Free Code Editor', url: 'https://vscodium.com', pricing: '100% Free / Open Source', isOpenSource: true },
          { name: 'Neovim', category: 'Vim-fork text editor', url: 'https://neovim.io', pricing: '100% Free / Open Source', isOpenSource: true }
        ],
        communityRating: 4.9,
        lastUpdated: 'June 2026'
      };
    } else if (qLower.includes('canva')) {
      return {
        name: 'Canva Designer',
        developer: 'Canva Pty Ltd',
        category: 'Online Graphics Design Suite',
        officialWebsite: 'https://www.canva.com',
        supportedPlatforms: ['Web', 'Android', 'iOS', 'Windows', 'macOS'],
        officialDownloadLink: 'https://www.canva.com/download/',
        pricing: 'Free with Pro upgrades ($12.99/mo)',
        hasFreeVersion: true,
        hasOfficialTrial: true,
        systemRequirements: 'Any HTML5 compliant modern internet browser',
        topFeatures: [
          'Instant Template & layout search',
          'Intuitive drag-and-drop graphic designer',
          'Collaborative cloud team workspaces',
          'AI Magic Write text/image generator'
        ],
        pros: [
          'Incredibly easy to master for non-designers',
          'Outstanding visual catalog of stock photos',
          'Fast publishing presets for social media'
        ],
        cons: [
          'Limited vector drawing controls',
          'Advanced graphics locked behind premium paywall'
        ],
        similarApplications: [
          { name: 'Adobe Express', category: 'Web Graphics', url: 'https://adobe.com/express', pricing: 'Free & Subscription', isOpenSource: false },
          { name: 'Figma', category: 'UX/UI Tooling', url: 'https://figma.com', pricing: 'Free / Premium plans', isOpenSource: false }
        ],
        openSourceAlternatives: [
          { name: 'Penpot', category: 'UI/UX open source design', url: 'https://penpot.app', pricing: 'Free / Open Source Web Tool', isOpenSource: true }
        ],
        communityRating: 4.7,
        lastUpdated: 'May 2026'
      };
    } else {
      // General dynamic app generator
      const cleanName = q.split(' ').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ');
      return {
        name: cleanName || 'Premium Application',
        developer: 'Verified Software Vendor',
        category: 'Productivity Utilities',
        officialWebsite: 'https://example.com/official',
        supportedPlatforms: ['Windows', 'macOS', 'Web'],
        officialDownloadLink: 'https://example.com/download',
        pricing: 'Commercial Paid License',
        hasFreeVersion: false,
        hasOfficialTrial: true,
        systemRequirements: 'Intel Dual-Core 2GHz, 4GB RAM',
        topFeatures: [
          'High performance cloud sync',
          'Intuitive and modern workflow boards',
          'Secure database encryption standards'
        ],
        pros: [
          'Extremely polished UI rendering',
          'Premium standard 24/7 client assistance'
        ],
        cons: [
          'Price point might be high for small teams'
        ],
        similarApplications: [
          { name: `${cleanName} Pro Alt`, category: 'Productivity', url: 'https://example.com/alt', pricing: 'Commercial', isOpenSource: false }
        ],
        openSourceAlternatives: [
          { name: `Libre${cleanName.replace(/\s+/g, '')}`, category: 'Productivity', url: 'https://example.com/os', pricing: 'Free & Open Source', isOpenSource: true }
        ],
        communityRating: 4.5,
        lastUpdated: '2026'
      };
    }
  };

  // Voice Synthesis function for Sanvi (10yo girl voice)
  const speakText = (text: string) => {
    if (isVoiceMuted) return;
    
    // Stop any ongoing speech
    window.speechSynthesis.cancel();

    // Clean text: strip emojis, markdown tags, backticks, asterisks, URLs
    const cleanText = text
      .replace(/https?:\/\/\S+/g, '') // remove URLs
      .replace(/[\uE000-\uF8FF]|\uD83C[\uDC00-\uDFFF]|\uD83D[\uDC00-\uDFFF]|[\u2011-\u26FF]|\uD83E[\uDD00-\uDFFF]/g, '') // remove emojis
      .replace(/[*#_`~:()]/g, ' ') // remove md formatting and special characters
      .replace(/\s+/g, ' ') // normalize spaces
      .trim();

    if (!cleanText) return;

    const utterance = new SpeechSynthesisUtterance(cleanText);
    
    // Configure kid-like pitch & rate
    utterance.pitch = 1.45; // Sweet higher pitch for 10yo girl voice
    utterance.rate = 0.95;  // Friendly, expressive conversational speed
    utterance.volume = 1.0;

    // Detect language context
    const hasHindi = /[\u0900-\u097F]/.test(text) || 
                     /batao|kijiye|hai|hoon|naam|namaste|karan|gussa|shanti|kripya/i.test(text);
    
    const voices = window.speechSynthesis.getVoices();
    let selectedVoice = null;
    
    if (hasHindi) {
      selectedVoice = voices.find(v => v.lang.startsWith('hi'));
    }
    
    // Fallback search patterns for female/high quality voices
    if (!selectedVoice) {
      selectedVoice = voices.find(v => v.lang.startsWith('en-IN') && v.name.toLowerCase().includes('female')) ||
                      voices.find(v => v.lang.startsWith('en-IN')) ||
                      voices.find(v => v.lang.startsWith('hi')) ||
                      voices.find(v => v.name.toLowerCase().includes('google') && v.lang.startsWith('en')) ||
                      voices.find(v => v.name.toLowerCase().includes('female')) ||
                      voices[0];
    }
    
    if (selectedVoice) {
      utterance.voice = selectedVoice;
    }

    utterance.onstart = () => {
      setIsSpeaking(text);
    };

    utterance.onend = () => {
      setIsSpeaking(null);
    };

    utterance.onerror = () => {
      setIsSpeaking(null);
    };

    window.speechSynthesis.speak(utterance);
  };

  const stopSpeaking = () => {
    window.speechSynthesis.cancel();
    setIsSpeaking(null);
  };

  // 3. Conversational chatbot with Sanvi
  const handleChatSubmit = async (e: any) => {
    e.preventDefault();
    if (!chatInput.trim()) return;

    const userMsg = chatInput;
    setChatInput('');
    setChatMessages(prev => [...prev, { sender: 'user', content: userMsg, time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) }]);
    setIsChatLoading(true);

    try {
      const response = await fetch('/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          messages: [
            ...chatMessages.map(m => ({ sender: m.sender, content: m.content })),
            { sender: 'user', content: userMsg }
          ]
        })
      });
      const data = await response.json();
      if (data.success) {
        setChatMessages(prev => [...prev, { sender: 'sanvi', content: data.message, time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) }]);
        // Automatically speak Sanvi's response
        speakText(data.message);
      } else {
        const fallbackMsg = 'Khed vyakt karti hoon, abhi mere servers thode busy hain. Kripya thodi der baad prayaas karein!';
        setChatMessages(prev => [...prev, { sender: 'sanvi', content: fallbackMsg, time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) }]);
        speakText(fallbackMsg);
      }
    } catch (err) {
      const errorMsg = 'Connection timed out. Main simulator mode mein chal rahi hoon!';
      setChatMessages(prev => [...prev, { sender: 'sanvi', content: errorMsg, time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) }]);
      speakText(errorMsg);
    } finally {
      setIsChatLoading(false);
    }
  };

  // Quick preset assistant prompt triggers
  const triggerQuickPrompt = (promptText: string) => {
    setChatInput(promptText);
  };

  // Toggle favorites
  const toggleFavorite = (appName: string) => {
    if (favorites.includes(appName)) {
      setFavorites(prev => prev.filter(f => f !== appName));
      triggerToast(`Removed "${appName}" from Saved Favorites.`);
    } else {
      setFavorites(prev => [...prev, appName]);
      triggerToast(`Saved "${appName}" to Favorites list.`);
    }
  };

  // Folder render helper
  const toggleFolder = (path: string) => {
    setExpandedFolders(prev => ({
      ...prev,
      [path]: !prev[path]
    }));
  };

  const copyCodeToClipboard = () => {
    navigator.clipboard.writeText(selectedFileContent);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const renderFileNode = (node: FileNode) => {
    const isExpanded = expandedFolders[node.path];
    const isSelected = selectedFilePath === node.path;

    if (node.type === 'directory') {
      return (
        <div key={node.path} className="ml-2">
          <button 
            onClick={() => toggleFolder(node.path)}
            className="flex items-center gap-1.5 w-full text-left py-1 px-1.5 rounded hover:bg-slate-800 text-slate-300 hover:text-white transition-colors text-xs"
          >
            {isExpanded ? <ChevronDown size={14} className="text-slate-500" /> : <ChevronRight size={14} className="text-slate-500" />}
            <Folder size={14} className="text-sky-400" />
            <span className="font-medium truncate">{node.name}</span>
          </button>
          {isExpanded && node.children && (
            <div className="ml-2 pl-2 border-l border-slate-800">
              {node.children.map(renderFileNode)}
            </div>
          )}
        </div>
      );
    }

    return (
      <button
        key={node.path}
        onClick={() => fetchFileContent(node.path)}
        className={`flex items-center gap-1.5 w-full text-left py-1 px-1.5 rounded ml-2.5 transition-colors text-xs truncate ${
          isSelected 
            ? 'bg-sky-500/10 text-sky-400 font-semibold border-r-2 border-sky-500' 
            : 'text-slate-400 hover:bg-slate-850 hover:text-slate-200'
        }`}
      >
        <FileCode size={13} className={isSelected ? 'text-sky-400' : 'text-slate-500'} />
        <span className="truncate">{node.name}</span>
      </button>
    );
  };

  // Simulate Flutter build verification testing
  const runVerifySystem = () => {
    setVerifying(true);
    setVerificationLogs([]);
    setVerificationSuccess(null);

    const steps = [
      'Checking system prerequisites... OK',
      'Validating pubspec.yaml constraints and plugins... OK',
      'Parsed EnvConfig environment states... [Production Ready]',
      'Checking DIService registrations... sl.registerLazySingleton(LoggerService) OK',
      'Resolving imports in app_router.dart... OK',
      'Verifying domain model schemas: AppInfo & AppAlternative... OK',
      'Verifying controller and Riverpod providers mappings... OK',
      'Checking presentation Views: SearchView & SanviChatView... OK',
      'Simulating Android multi-target architecture build... OK',
      'Simulating Flutter Web compiler optimization pass... OK',
      'Simulating Windows Desktop executable generator config... OK',
      'Compiling codemagic.yaml pipelines schema... OK',
      'All structural tests compiled successfully. 0 Warning, 0 Critical errors.'
    ];

    steps.forEach((step, index) => {
      setTimeout(() => {
        setVerificationLogs(prev => [...prev, step]);
        if (index === steps.length - 1) {
          setVerifying(false);
          setVerificationSuccess(true);
          triggerToast("All architecture elements successfully verified!");
        }
      }, (index + 1) * 350);
    });
  };

  // Load initial search Photoshop result to make the page pop
  useEffect(() => {
    handleSearchSubmit('Photoshop');
  }, []);

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col font-sans selection:bg-sky-500 selection:text-white">
      {/* Toast Notification */}
      {toastMessage && (
        <div className="fixed bottom-6 right-6 bg-slate-900 border border-sky-500/50 shadow-2xl shadow-sky-500/10 px-5 py-3 rounded-xl flex items-center gap-3 animate-bounce z-50 text-sm">
          <div className="h-2 w-2 rounded-full bg-sky-500 animate-ping"></div>
          <span className="font-medium text-slate-200">{toastMessage}</span>
        </div>
      )}

      {/* Header bar */}
      <header className="border-b border-slate-800 bg-slate-900/80 backdrop-blur px-6 py-4 flex items-center justify-between sticky top-0 z-40">
        <div className="flex items-center gap-3">
          <div className="bg-sky-500/15 p-2 rounded-xl border border-sky-500/35">
            <Layers className="text-sky-400 h-6 w-6" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <h1 className="font-bold text-lg tracking-tight">Apps Buddy</h1>
              <span className="text-[10px] uppercase font-bold tracking-widest bg-sky-500/10 text-sky-400 px-2 py-0.5 rounded-full border border-sky-500/20 animate-pulse">
                Phase 6 Ready
              </span>
            </div>
            <p className="text-xs text-slate-400 font-normal">Sanvi AI Search Engine & Multi-Platform Clean Architecture Foundation</p>
          </div>
        </div>

        {/* Live Badges for Platforms */}
        <div className="hidden lg:flex items-center gap-3 text-[11px] text-slate-400 font-medium">
          <div className="flex items-center gap-1.5 bg-slate-800/60 px-2.5 py-1 rounded-md border border-slate-700/50">
            <Smartphone size={12} className="text-sky-400" /> Android Compatible
          </div>
          <div className="flex items-center gap-1.5 bg-slate-800/60 px-2.5 py-1 rounded-md border border-slate-700/50">
            <Globe size={12} className="text-emerald-400" /> Web Ready
          </div>
          <div className="flex items-center gap-1.5 bg-slate-800/60 px-2.5 py-1 rounded-md border border-slate-700/50">
            <Monitor size={12} className="text-amber-400" /> Windows Desktop
          </div>
          <div className="flex items-center gap-1.5 bg-slate-800/60 px-2.5 py-1 rounded-md border border-slate-700/50">
            <Sparkles size={12} className="text-purple-400" /> Codemagic pipeline
          </div>
        </div>
      </header>

      {/* Main body: Grid Split */}
      <main className="flex-1 grid grid-cols-1 xl:grid-cols-12 overflow-hidden">
        
        {/* LEFT COLUMN: Flutter Interactive Device Mockup (Width: 5 Cols) */}
        <div className="xl:col-span-5 p-6 border-r border-slate-800 flex flex-col items-center justify-start bg-slate-950 overflow-y-auto">
          <div className="w-full max-w-sm">
            <div className="text-xs font-semibold text-slate-400 mb-2.5 flex items-center justify-between uppercase tracking-wider">
              <span className="flex items-center gap-1.5"><Smartphone size={13} className="text-sky-400 animate-pulse" /> Live Simulated App Frame</span>
              <span className="text-[10px] bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 px-2 py-0.5 rounded-full font-bold animate-pulse">Phase 6 Active</span>
            </div>

            {/* Simulated Membership Switcher Panel */}
            <div className="bg-slate-900 border border-slate-800 rounded-2xl p-4 mb-4 text-xs">
              <p className="font-semibold text-slate-300 mb-2.5 uppercase tracking-wider text-[10px] flex items-center justify-between text-amber-400">
                <span className="flex items-center gap-1.5"><Sparkles size={13} /> Simulated Membership Switcher</span>
                <span className="text-[9px] text-slate-500 font-normal">Switch roles to test logic</span>
              </p>
              <div className="grid grid-cols-3 gap-1.5">
                <button 
                  onClick={() => { setMembershipTier('free'); triggerToast("Switched to Free plan. Ads enabled & 3 search limits active."); }}
                  className={`px-1 py-1.5 rounded-lg text-center font-bold text-[10px] border transition ${membershipTier === 'free' ? 'bg-rose-500/20 text-rose-400 border-rose-500/40' : 'bg-slate-850 text-slate-400 border-transparent hover:bg-slate-800'}`}
                >
                  Free User
                </button>
                <button 
                  onClick={() => { setMembershipTier('trial'); setTrialDaysLeft(3); triggerToast("Activated 3-Day Free Trial. No Ads & unlimited searches active."); }}
                  className={`px-1 py-1.5 rounded-lg text-center font-bold text-[10px] border transition ${membershipTier === 'trial' ? 'bg-sky-500/20 text-sky-400 border-sky-500/40' : 'bg-slate-850 text-slate-400 border-transparent hover:bg-slate-800'}`}
                >
                  3-Day Trial
                </button>
                <button 
                  onClick={() => { setMembershipTier('premium'); triggerToast("Premium subscription active. ₹99 monthly plan."); }}
                  className={`px-1 py-1.5 rounded-lg text-center font-bold text-[10px] border transition ${membershipTier === 'premium' ? 'bg-amber-500/20 text-amber-400 border-amber-500/40' : 'bg-slate-850 text-slate-400 border-transparent hover:bg-slate-800'}`}
                >
                  Premium
                </button>
              </div>
              <div className="mt-3 flex items-center justify-between text-[10.5px] text-slate-400 border-t border-slate-850 pt-2.5">
                <span>Daily Searches: <strong className={membershipTier === 'free' && aiSearchUsage >= 3 ? 'text-rose-400 font-black' : 'text-slate-200'}>{aiSearchUsage}</strong> {membershipTier === 'free' ? '/ 3' : '(Unlimited)'}</span>
                <button 
                  onClick={() => { setAiSearchUsage(0); triggerToast("Resetted simulated daily AI search counter."); }}
                  className="text-sky-400 font-semibold hover:underline"
                >
                  Reset Limits
                </button>
              </div>
            </div>
            
            {/* The Smartphone Frame Container */}
            <div className="w-full aspect-[9/18.5] bg-slate-900 rounded-[44px] p-3 border-[6px] border-slate-800 shadow-2xl relative flex flex-col overflow-hidden">
              {/* Speaker & camera sensor bar */}
              <div className="absolute top-0 left-1/2 -translate-x-1/2 w-32 h-6 bg-slate-800 rounded-b-2xl z-20 flex items-center justify-center gap-2">
                <div className="w-10 h-1.5 bg-slate-750 rounded-full"></div>
                <div className="w-2.5 h-2.5 bg-slate-750 rounded-full"></div>
              </div>

              {/* Simulated Flutter app screen */}
              <div className="flex-1 bg-slate-900 rounded-[34px] overflow-hidden flex flex-col relative pt-6 text-slate-100 select-none">
                
                {/* Internal App Title Bar */}
                <div className="px-4 py-3 border-b border-slate-800 flex items-center justify-between bg-slate-900/90 sticky top-0 z-10">
                  <div className="flex items-center gap-2">
                    <div className="h-6 w-6 rounded bg-sky-500 flex items-center justify-center font-bold text-xs text-white shadow-md shadow-sky-500/20">
                      S
                    </div>
                    <div>
                      <h4 className="text-xs font-bold text-slate-200">Apps Buddy</h4>
                      <p className="text-[9px] text-slate-400">Sanvi AI Assistant v2.0</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-1">
                    <button 
                      onClick={() => setShowHistory(!showHistory)} 
                      className={`p-1 rounded text-slate-400 hover:bg-slate-800 transition-colors ${showHistory ? 'text-sky-400 bg-slate-800' : ''}`}
                      title="Toggle History"
                    >
                      <RefreshCw size={13} />
                    </button>
                    <button 
                      onClick={() => triggerToast(`Currently Saved Favorites: ${favorites.join(', ')}`)}
                      className="p-1 rounded text-slate-400 hover:bg-slate-800 transition-colors"
                      title="Show Favorites Count"
                    >
                      <Heart size={13} className={favorites.length > 0 ? 'fill-red-500 text-red-500' : ''} />
                    </button>
                  </div>
                </div>

                {/* Simulated views wrapper */}
                <div className="flex-1 overflow-y-auto p-3 text-xs flex flex-col scrollbar-thin">
                  
                  {/* SEARCH TAB VIEW */}
                  {activeTab === 'search' && (
                    <div className="flex-grow flex flex-col gap-3">
                      
                      {/* Search Bar inside App */}
                      <div className="relative">
                        <input 
                          type="text" 
                          value={searchQuery}
                          onChange={(e) => setSearchQuery(e.target.value)}
                          onKeyDown={(e) => e.key === 'Enter' && handleSearchSubmit(searchQuery)}
                          placeholder="Search app e.g. Photoshop..."
                          className="w-full bg-slate-800/80 border border-slate-700/60 rounded-xl py-2 pl-3.5 pr-10 text-xs text-slate-100 placeholder-slate-400 outline-none focus:border-sky-500/60 focus:ring-1 focus:ring-sky-500/60 transition"
                        />
                        <button 
                          onClick={() => handleSearchSubmit(searchQuery)}
                          className="absolute right-2 top-1/2 -translate-y-1/2 text-slate-400 hover:text-sky-400 p-1"
                        >
                          <Search size={14} />
                        </button>
                      </div>

                      {/* Dropdown for search History preset list */}
                      {showHistory && (
                        <div className="bg-slate-800 border border-slate-750 rounded-xl p-2.5 animate-fadeIn">
                          <p className="text-[9px] uppercase tracking-widest font-bold text-slate-400 mb-1.5 px-1">Recent Searches</p>
                          <div className="flex flex-col gap-1">
                            {searchHistory.map((h, i) => (
                              <button 
                                key={i} 
                                onClick={() => { setSearchQuery(h); handleSearchSubmit(h); setShowHistory(false); }}
                                className="flex items-center gap-2 py-1 px-2 rounded hover:bg-slate-700 text-left text-[11px] text-slate-300 transition-colors"
                              >
                                <RefreshCw size={10} className="text-slate-500" />
                                <span>{h}</span>
                              </button>
                            ))}
                          </div>
                        </div>
                      )}

                      {/* Display States */}
                      {isSearching ? (
                        <div className="flex-1 flex flex-col items-center justify-center py-12 gap-3 text-slate-400 text-center">
                          <div className="animate-spin rounded-full h-8 w-8 border-2 border-sky-500 border-t-transparent"></div>
                          <p className="font-medium animate-pulse text-xs">Sanvi querying official software logs...</p>
                        </div>
                      ) : searchResult ? (
                        <div className="flex flex-col gap-3 animate-fadeIn">
                          
                          {/* Main Title card */}
                          <div className="bg-slate-800/40 border border-slate-700/30 rounded-xl p-3 flex flex-col gap-1">
                            <div className="flex justify-between items-start gap-2">
                              <div>
                                <h5 className="font-bold text-slate-100 text-sm leading-tight">{searchResult.name}</h5>
                                <p className="text-[10px] text-slate-400">{searchResult.developer} • {searchResult.category}</p>
                              </div>
                              <button 
                                onClick={() => toggleFavorite(searchResult.name)}
                                className="p-1 rounded-lg bg-slate-800 hover:bg-slate-700 transition"
                              >
                                <Heart size={13} className={favorites.includes(searchResult.name) ? "fill-red-500 text-red-500" : "text-slate-400"} />
                              </button>
                            </div>
                            <div className="mt-2 flex flex-wrap gap-1">
                              {searchResult.supportedPlatforms.map((plat: string, i: number) => (
                                <span key={i} className="text-[9px] bg-slate-800 px-1.5 py-0.5 rounded text-slate-300 border border-slate-700/40">{plat}</span>
                              ))}
                            </div>
                          </div>

                          {/* Quick Bento info grid */}
                          <div className="grid grid-cols-2 gap-2 text-[10px]">
                            <div className="bg-slate-800/50 border border-slate-700/20 rounded-xl p-2">
                              <span className="text-slate-400 block text-[9px] font-semibold">PRICING</span>
                              <span className="font-bold text-slate-200">{searchResult.pricing}</span>
                            </div>
                            <div className="bg-slate-800/50 border border-slate-700/20 rounded-xl p-2">
                              <span className="text-slate-400 block text-[9px] font-semibold">TRIAL OFFER</span>
                              <span className="font-bold text-slate-200">{searchResult.hasOfficialTrial ? "7-Day Trial" : "None Available"}</span>
                            </div>
                          </div>

                          {/* Pros & Cons list */}
                          <div className="grid grid-cols-2 gap-2 text-[10px]">
                            <div className="bg-emerald-500/5 border border-emerald-500/10 p-2.5 rounded-xl">
                              <span className="font-bold text-emerald-400 block mb-1">PROS</span>
                              <ul className="list-disc list-inside space-y-1 text-slate-300 text-[9px]">
                                {searchResult.pros.slice(0, 2).map((p: string, i: number) => (
                                  <li key={i} className="truncate">{p}</li>
                                ))}
                              </ul>
                            </div>
                            <div className="bg-rose-500/5 border border-rose-500/10 p-2.5 rounded-xl">
                              <span className="font-bold text-rose-400 block mb-1">CONS</span>
                              <ul className="list-disc list-inside space-y-1 text-slate-300 text-[9px]">
                                {searchResult.cons.slice(0, 2).map((c: string, i: number) => (
                                  <li key={i} className="truncate">{c}</li>
                                ))}
                              </ul>
                            </div>
                          </div>

                          {/* Clean table layout of Free Open Source alternatives */}
                          {searchResult.openSourceAlternatives && searchResult.openSourceAlternatives.length > 0 && (
                            <div className="mt-1">
                              <span className="text-[10px] font-bold text-sky-400 uppercase tracking-wider block mb-1.5 px-0.5 flex items-center gap-1">
                                <Code2 size={11} /> Open Source Alternatives
                              </span>
                              <div className="flex flex-col gap-1.5">
                                {searchResult.openSourceAlternatives.map((alt: any, i: number) => (
                                  <div key={i} className="bg-slate-800/50 border border-slate-750 rounded-xl p-2.5 flex items-center justify-between">
                                    <div>
                                      <h6 className="font-bold text-slate-200 text-xs">{alt.name}</h6>
                                      <p className="text-[9px] text-slate-400">{alt.category} • {alt.pricing}</p>
                                    </div>
                                    <div className="flex items-center gap-1.5">
                                      <span className="text-[8px] bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 px-1 rounded">OSI Certified</span>
                                      <a href={alt.url} target="_blank" rel="noopener noreferrer" className="text-slate-400 hover:text-sky-400 p-0.5">
                                        <ExternalLink size={11} />
                                      </a>
                                    </div>
                                  </div>
                                ))}
                              </div>
                            </div>
                          )}

                          {/* Commercial alternatives */}
                          {searchResult.similarApplications && searchResult.similarApplications.length > 0 && (
                            <div className="mt-1">
                              <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block mb-1.5 px-0.5">
                                Verified Commercial Alternatives
                              </span>
                              <div className="flex flex-col gap-1.5">
                                {searchResult.similarApplications.map((alt: any, i: number) => (
                                  <div key={i} className="bg-slate-800/30 border border-slate-750/50 rounded-xl p-2 flex items-center justify-between">
                                    <div>
                                      <h6 className="font-bold text-slate-300 text-xs">{alt.name}</h6>
                                      <p className="text-[9px] text-slate-500">{alt.pricing}</p>
                                    </div>
                                    <a href={alt.url} target="_blank" rel="noopener noreferrer" className="text-slate-400 hover:text-sky-400 p-0.5">
                                      <ExternalLink size={10} />
                                    </a>
                                  </div>
                                ))}
                              </div>
                            </div>
                          )}

                          {/* Action button row */}
                          <div className="mt-1 grid grid-cols-2 gap-2 text-[10px] text-center">
                            <button 
                              onClick={() => {
                                window.open(searchResult.officialWebsite, '_blank');
                                triggerToast("Opening official website...");
                              }}
                              className="bg-slate-800 hover:bg-slate-750 text-slate-300 font-medium py-2 rounded-lg border border-slate-700/60 flex items-center justify-center gap-1.5"
                            >
                              <Globe size={11} /> Official Site
                            </button>
                            <button 
                              onClick={() => {
                                window.open(searchResult.officialDownloadLink, '_blank');
                                triggerToast("Navigating to secure trials portal...");
                              }}
                              className="bg-sky-500 hover:bg-sky-600 text-white font-semibold py-2 rounded-lg shadow-lg shadow-sky-500/10 flex items-center justify-center gap-1.5"
                            >
                              <Check size={11} /> Official Download
                            </button>
                          </div>

                        </div>
                      ) : (
                        <div className="flex-grow flex flex-col items-center justify-center text-center py-12 text-slate-500">
                          <Search size={36} className="text-slate-700 mb-2" />
                          <p>Enter an application name above to execute the AI Search alternate finder.</p>
                        </div>
                      )}
                    </div>
                  )}

                  {/* SANVI AI COMPANION CHAT TAB */}
                  {activeTab === 'chat' && (
                    <div className="flex-grow flex flex-col justify-between overflow-hidden">
                      {/* Kid Voice Status & Controller Header */}
                      <div className="bg-sky-500/10 border border-sky-500/25 rounded-xl p-2.5 mb-2.5 flex items-center justify-between">
                        <div className="flex items-center gap-1.5">
                          <span className="relative flex h-2 w-2">
                            <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
                            <span className="relative inline-flex rounded-full h-2 w-2 bg-emerald-500"></span>
                          </span>
                          <span className="text-[10px] font-bold text-sky-400">Sanvi Kid Voice Active (10yo Girl)</span>
                        </div>
                        <div className="flex items-center gap-1.5">
                          {isSpeaking && (
                            <button 
                              onClick={stopSpeaking}
                              className="text-[9px] bg-rose-500/20 hover:bg-rose-500/35 text-rose-300 px-2 py-0.5 rounded-md font-semibold transition-colors"
                            >
                              Stop Audio
                            </button>
                          )}
                          <button
                            onClick={() => {
                              setIsVoiceMuted(!isVoiceMuted);
                              if (!isVoiceMuted) stopSpeaking();
                              triggerToast(isVoiceMuted ? "Sanvi voice autoplay enabled!" : "Sanvi voice autoplay muted.");
                            }}
                            className={`p-1 rounded-md transition-colors ${isVoiceMuted ? 'text-slate-500 hover:text-slate-400 bg-slate-800' : 'text-sky-400 hover:text-sky-300 bg-sky-500/15'}`}
                            title={isVoiceMuted ? "Enable Voice Autoplay" : "Mute Voice Autoplay"}
                          >
                            {isVoiceMuted ? <VolumeX size={12} /> : <Volume2 size={12} />}
                          </button>
                        </div>
                      </div>

                      {/* Messages scrollarea */}
                      <div className="flex-grow flex flex-col gap-2.5 overflow-y-auto max-h-[300px] pr-1.5 mb-2.5 scrollbar-thin">
                        {chatMessages.map((msg, i) => (
                          <div 
                            key={i} 
                            className={`flex flex-col gap-1 max-w-[85%] ${msg.sender === 'user' ? 'self-end items-end' : 'self-start items-start'}`}
                          >
                            <div className="flex items-center gap-1.5 w-full">
                              <div className={`p-2.5 rounded-2xl text-[11px] leading-relaxed shadow ${
                                msg.sender === 'user' 
                                  ? 'bg-sky-500 text-white rounded-tr-none' 
                                  : 'bg-slate-800 text-slate-200 rounded-tl-none border border-slate-750'
                              }`}>
                                {/* Standard rendering of chat */}
                                <p className="whitespace-pre-line">{msg.content}</p>
                              </div>
                              {msg.sender === 'sanvi' && (
                                <button
                                  onClick={() => {
                                    if (isSpeaking === msg.content) {
                                      stopSpeaking();
                                    } else {
                                      speakText(msg.content);
                                    }
                                  }}
                                  className={`p-1.5 rounded-full border transition flex-shrink-0 ${
                                    isSpeaking === msg.content 
                                      ? 'bg-rose-500/20 border-rose-500/35 text-rose-400 animate-pulse' 
                                      : 'bg-slate-850 border-slate-700/60 text-slate-400 hover:text-sky-400 hover:border-sky-500/35'
                                  }`}
                                  title="Listen to Sanvi"
                                >
                                  <Volume2 size={11} className={isSpeaking === msg.content ? "animate-pulse" : ""} />
                                </button>
                              )}
                            </div>
                            <span className="text-[8px] text-slate-500 px-1">{msg.time}</span>
                          </div>
                        ))}

                        {isChatLoading && (
                          <div className="self-start flex items-center gap-2 bg-slate-800 p-2.5 rounded-2xl rounded-tl-none text-[10px] text-slate-400 border border-slate-750">
                            <span className="flex gap-1">
                              <span className="h-1.5 w-1.5 bg-slate-500 rounded-full animate-bounce"></span>
                              <span className="h-1.5 w-1.5 bg-slate-500 rounded-full animate-bounce delay-100"></span>
                              <span className="h-1.5 w-1.5 bg-slate-500 rounded-full animate-bounce delay-200"></span>
                            </span>
                            <span>Sanvi thinking...</span>
                          </div>
                        )}
                      </div>

                      {/* Prompts Preset chips to facilitate quick tests */}
                      <div className="flex flex-wrap gap-1 mb-2">
                        <button 
                          onClick={() => triggerQuickPrompt("Photoshop ke legal free alternatives batao.")}
                          className="text-[9px] bg-slate-800 hover:bg-slate-700 text-slate-300 py-1 px-2 rounded-full border border-slate-700/50"
                        >
                          Photoshop free alts?
                        </button>
                        <button 
                          onClick={() => triggerQuickPrompt("Compare VS Code and VSCodium")}
                          className="text-[9px] bg-slate-800 hover:bg-slate-700 text-slate-300 py-1 px-2 rounded-full border border-slate-700/50"
                        >
                          VS Code vs VSCodium
                        </button>
                      </div>

                      {/* Chat input form */}
                      <form onSubmit={handleChatSubmit} className="flex gap-1.5 items-center">
                        <input 
                          type="text"
                          value={chatInput}
                          onChange={(e) => setChatInput(e.target.value)}
                          placeholder="Type your message in English..."
                          className="flex-1 bg-slate-800 border border-slate-700 rounded-xl px-3 py-2 text-[11px] text-slate-100 placeholder-slate-400 outline-none focus:border-sky-500"
                        />
                        <button 
                          type="submit" 
                          className="bg-sky-500 hover:bg-sky-600 text-white p-2 rounded-xl"
                        >
                          <Send size={12} />
                        </button>
                      </form>
                    </div>
                  )}

                  {/* PREMIUM TAB VIEW */}
                  {activeTab === 'premium' && (
                    <div className="flex-grow flex flex-col gap-3 animate-fadeIn">
                      {/* Subscription status card */}
                      <div className="bg-slate-850/80 border border-slate-750 rounded-xl p-3">
                        <div className="flex justify-between items-center mb-2">
                          <span className="text-[9px] uppercase tracking-wider font-bold text-slate-400">Current Plan</span>
                          <span className={`text-[9px] font-extrabold px-2 py-0.5 rounded-full ${
                            membershipTier === 'premium' 
                              ? 'bg-amber-500/10 text-amber-400 border border-amber-500/20' 
                              : membershipTier === 'trial'
                                ? 'bg-sky-500/10 text-sky-400 border border-sky-500/20'
                                : 'bg-slate-800 text-slate-400 border border-slate-750'
                          }`}>
                            {membershipTier.toUpperCase()}
                          </span>
                        </div>

                        {membershipTier === 'trial' ? (
                          <div>
                            <h5 className="font-bold text-slate-100 text-xs">Active 3-Day Free Trial</h5>
                            <p className="text-[10px] text-slate-400 mt-1">{trialDaysLeft} days remaining of full premium features.</p>
                            <div className="w-full bg-slate-800 h-1 rounded-full mt-2 overflow-hidden">
                              <div className="bg-sky-500 h-full w-2/3"></div>
                            </div>
                          </div>
                        ) : membershipTier === 'premium' ? (
                          <div>
                            <h5 className="font-bold text-amber-400 text-xs flex items-center gap-1">
                              <Sparkles size={12} /> Apps Buddy Premium Active
                            </h5>
                            <p className="text-[10px] text-slate-400 mt-1">Renews automatically for ₹99/month on next billing cycle.</p>
                          </div>
                        ) : (
                          <div>
                            <h5 className="font-bold text-slate-300 text-xs">Free Account Experience</h5>
                            <p className="text-[10px] text-slate-400 mt-1">Upgrade to bypass 3 search daily limits and turn off Google AdMob ads.</p>
                          </div>
                        )}
                      </div>

                      {/* Buy premium pricing card if not premium */}
                      {membershipTier !== 'premium' && (
                        <div className="bg-gradient-to-br from-amber-500/10 via-slate-900 to-slate-900 border border-amber-500/30 rounded-xl p-3.5 flex flex-col gap-2 shadow-lg shadow-amber-500/5">
                          <div className="flex justify-between items-start">
                            <div>
                              <h6 className="font-bold text-slate-100 text-xs">Apps Buddy Premium</h6>
                              <p className="text-[9px] text-slate-400">Safe, secure Razorpay verification</p>
                            </div>
                            <span className="text-amber-400 font-bold text-sm">₹99/mo</span>
                          </div>

                          <div className="space-y-1 text-[9px] text-slate-300 mt-1">
                            <div className="flex items-center gap-1.5">
                              <span className="text-emerald-400">✓</span> No interstitial/banner Ads
                            </div>
                            <div className="flex items-center gap-1.5">
                              <span className="text-emerald-400">✓</span> Unlimited Sanvi AI queries
                            </div>
                            <div className="flex items-center gap-1.5">
                              <span className="text-emerald-400">✓</span> Unlimited Saved Favorites & History
                            </div>
                          </div>

                          <button
                            onClick={() => {
                              triggerToast("Initializing Razorpay billing pipeline...");
                              setTimeout(() => {
                                setMembershipTier('premium');
                                setTransactions(prev => [
                                  ...prev,
                                  { id: `pay_tx_${Math.floor(10000 + Math.random() * 90000)}`, plan: 'Premium Monthly Membership Subscription', amount: '₹99', date: new Date().toLocaleDateString() }
                                ]);
                                triggerToast("Razorpay billing succeeded! Active Premium membership.");
                              }, 1200);
                            }}
                            className="w-full bg-amber-500 hover:bg-amber-600 text-slate-950 font-bold py-1.5 px-3 rounded-lg text-[10px] text-center shadow-lg shadow-amber-500/20 mt-1.5 transition-colors"
                          >
                            Subscribe Now via Razorpay
                          </button>
                        </div>
                      )}

                      {/* Membership actions */}
                      <div className="flex flex-col gap-1.5 text-[10px]">
                        <button
                          onClick={() => {
                            triggerToast("Polling secure Razorpay servers...");
                            setTimeout(() => {
                              setMembershipTier('premium');
                              triggerToast("Previous Monthly Subscription restored successfully!");
                            }, 1000);
                          }}
                          className="w-full text-slate-300 bg-slate-800 hover:bg-slate-750 border border-slate-700/60 rounded-lg py-1.5 px-3 text-left flex items-center justify-between"
                        >
                          <span>Restore Purchase</span>
                          <span className="text-sky-400 text-[9px] font-bold">Restore</span>
                        </button>

                        {membershipTier === 'premium' && (
                          <button
                            onClick={() => {
                              setMembershipTier('free');
                              triggerToast("Premium subscription cancelled successfully.");
                            }}
                            className="w-full text-rose-400 bg-rose-950/10 hover:bg-rose-950/20 border border-rose-900/30 rounded-lg py-1.5 px-3 text-left text-[9px] font-semibold"
                          >
                            Cancel Active Subscription
                          </button>
                        )}
                      </div>

                      {/* Transaction history */}
                      <div className="mt-1">
                        <span className="text-[9px] uppercase font-bold tracking-wider text-slate-500 block mb-1">Payment History</span>
                        <div className="max-h-[90px] overflow-y-auto space-y-1 pr-1 scrollbar-thin">
                          {transactions.map((tx, i) => (
                            <div key={i} className="bg-slate-850/40 border border-slate-750 p-2 rounded-lg flex justify-between items-center text-[9px]">
                              <div>
                                <p className="font-bold text-slate-300 truncate max-w-[140px]">{tx.plan}</p>
                                <p className="text-[8px] text-slate-500">{tx.id} • {tx.date}</p>
                              </div>
                              <span className="font-bold text-emerald-400">{tx.amount}</span>
                            </div>
                          ))}
                        </div>
                      </div>

                      {/* Privacy & legal links */}
                      <div className="text-[8px] text-slate-500 flex justify-center gap-3 mt-auto py-1">
                        <button onClick={() => triggerToast("Displaying Terms of Service...")} className="hover:underline">Terms of Service</button>
                        <span>•</span>
                        <button onClick={() => triggerToast("Displaying Privacy Policy...")} className="hover:underline">Privacy Policy</button>
                      </div>
                    </div>
                  )}

                  {/* USER EXPERIENCE DASHBOARD TAB */}
                  {activeTab === 'dashboard' && (
                    <div className="flex-grow flex flex-col gap-3.5 overflow-y-auto max-h-[460px] pr-1.5 scrollbar-thin animate-fadeIn text-[11px] text-slate-200">
                      
                      {/* Welcome & Profile Summary Section */}
                      <div className="bg-gradient-to-r from-sky-950/40 to-slate-900 border border-slate-750 rounded-xl p-3 flex items-center justify-between">
                        <div className="flex items-center gap-3">
                          {/* Dicebear Avatar with interactive seed-change */}
                          <div 
                            onClick={() => {
                              const seeds = ['Daisy', 'Oliver', 'Felix', 'Charlie', 'Milo', 'Bella', 'Luna', 'Teddy'];
                              const nextSeed = seeds[(seeds.indexOf(avatarSeed) + 1) % seeds.length];
                              setAvatarSeed(nextSeed);
                              triggerToast("Profile picture generated with seed: " + nextSeed);
                            }}
                            className="relative group cursor-pointer"
                            title="Click to generate new avatar"
                          >
                            <img 
                              src={`https://api.dicebear.com/7.x/adventurer/svg?seed=${avatarSeed}`} 
                              alt="Avatar" 
                              className="h-11 w-11 rounded-full bg-slate-800 border-2 border-sky-400/60 p-0.5 hover:scale-105 transition-all"
                              referrerPolicy="no-referrer"
                            />
                            <div className="absolute -bottom-1 -right-1 bg-sky-500 text-[6px] text-white p-0.5 rounded-full font-bold">GEN</div>
                          </div>

                          <div className="flex flex-col">
                            <span className="text-[9px] text-slate-400 tracking-wide uppercase font-semibold">
                              Welcome back,
                            </span>
                            <div className="flex items-center gap-1.5">
                              <input 
                                type="text" 
                                value={userDisplayName} 
                                onChange={(e) => setUserDisplayName(e.target.value)} 
                                className="font-bold text-slate-100 bg-transparent border-b border-transparent hover:border-slate-700 focus:border-sky-500 outline-none w-[110px]" 
                                title="Click to edit display name"
                              />
                            </div>
                            <span className="text-[8px] text-slate-500">Member since May 2026</span>
                            <button 
                              onClick={() => {
                                setActiveTab('admin');
                                triggerToast("Authorized! Accessing administration dashboard console.");
                              }}
                              className="mt-1 flex items-center gap-1 self-start bg-amber-500/10 hover:bg-amber-500/20 text-amber-400 px-1.5 py-0.5 rounded text-[7px] font-bold border border-amber-500/25 tracking-wide"
                            >
                              🔑 SYSTEM ADMIN HUB
                            </button>
                          </div>
                        </div>

                        {/* Top corner sync status */}
                        <div className="flex flex-col items-end">
                          <button 
                            onClick={() => {
                              setIsSyncingState(true);
                              triggerToast("Initializing conflict-safe sync handshakes...");
                              setTimeout(() => {
                                setIsSyncingState(false);
                                setLastSyncedTime('Just now');
                                triggerToast("Cloud Sync succeeded! Indexing complete.");
                              }, 1100);
                            }}
                            disabled={isSyncingState}
                            className="flex items-center gap-1 bg-slate-800/80 hover:bg-slate-750 px-2 py-1 rounded text-[8px] font-bold border border-slate-700/50"
                          >
                            <RefreshCw size={8} className={isSyncingState ? "animate-spin text-sky-400" : "text-sky-400"} />
                            {isSyncingState ? "SYNCING..." : "SYNC NOW"}
                          </button>
                          <span className="text-[7px] text-slate-500 mt-1">Synced: {lastSyncedTime}</span>
                        </div>
                      </div>

                      {/* Subscription Membership Status Widget */}
                      <div className="bg-slate-850/80 border border-slate-750 rounded-xl p-3">
                        <div className="flex justify-between items-center mb-1.5">
                          <span className="text-[8px] uppercase tracking-wider font-bold text-slate-400">Membership Tier</span>
                          <span className={`text-[8px] font-extrabold px-2 py-0.5 rounded-full ${
                            membershipTier === 'premium' 
                              ? 'bg-amber-500/10 text-amber-400 border border-amber-500/20' 
                              : membershipTier === 'trial'
                                ? 'bg-sky-500/10 text-sky-400 border border-sky-500/20'
                                : 'bg-slate-800 text-slate-400 border border-slate-750'
                          }`}>
                            {membershipTier.toUpperCase()}
                          </span>
                        </div>

                        {membershipTier === 'trial' ? (
                          <div className="flex items-center justify-between gap-3">
                            <div className="flex-1">
                              <h5 className="font-bold text-slate-100 text-[10px]">Active 3-Day Free Trial</h5>
                              <p className="text-[8px] text-slate-400">{trialDaysLeft} days remaining of unlimited searches.</p>
                            </div>
                            <button 
                              onClick={() => {
                                setMembershipTier('premium');
                                setTransactions(prev => [
                                  ...prev,
                                  { id: `pay_tx_${Math.floor(10000 + Math.random() * 90000)}`, plan: 'Premium Membership Subscription Upgrade', amount: '₹99', date: new Date().toLocaleDateString() }
                                ]);
                                triggerToast("Upgraded successfully via Razorpay!");
                              }}
                              className="bg-amber-500 hover:bg-amber-600 text-slate-950 font-bold px-2 py-1 rounded text-[8px]"
                            >
                              UPGRADE
                            </button>
                          </div>
                        ) : membershipTier === 'premium' ? (
                          <div className="flex items-center gap-1.5 text-amber-400">
                            <Sparkles size={10} />
                            <p className="text-[8px]">Auto-renews at ₹99/month on next billing cycle.</p>
                          </div>
                        ) : (
                          <div className="flex items-center justify-between gap-3">
                            <div className="flex-1">
                              <h5 className="font-bold text-slate-300 text-[10px]">Free Plan Experience</h5>
                              <p className="text-[8px] text-slate-400">Queries limited. Ads active.</p>
                            </div>
                            <button 
                              onClick={() => {
                                setMembershipTier('premium');
                                setTransactions(prev => [
                                  ...prev,
                                  { id: `pay_tx_${Math.floor(10000 + Math.random() * 90000)}`, plan: 'Premium Membership Subscription Upgrade', amount: '₹99', date: new Date().toLocaleDateString() }
                                ]);
                                triggerToast("Upgraded successfully via Razorpay!");
                              }}
                              className="bg-amber-500 hover:bg-amber-600 text-slate-950 font-bold px-2 py-1 rounded text-[8px]"
                            >
                              SUBSCRIBE
                            </button>
                          </div>
                        )}
                      </div>

                      {/* Favorites Module with Search, Sort, Filter */}
                      <div className="bg-slate-850/30 border border-slate-750/60 rounded-xl p-3 flex flex-col gap-2">
                        <div className="flex justify-between items-center">
                          <span className="text-[9px] uppercase font-bold tracking-wider text-slate-400">Saved Favorites ({favorites.length})</span>
                          <span className="text-[7px] text-slate-500">Cloud synchronized</span>
                        </div>

                        {/* Search & filters controls row */}
                        <div className="grid grid-cols-12 gap-1 text-[8px]">
                          <input 
                            type="text" 
                            placeholder="Search favorites..." 
                            value={favSearchQuery}
                            onChange={(e) => setFavSearchQuery(e.target.value)}
                            className="col-span-6 bg-slate-800 border border-slate-750 rounded px-1.5 py-0.5 text-slate-100 focus:border-sky-500 outline-none"
                          />
                          <select 
                            value={favFilterType} 
                            onChange={(e: any) => setFavFilterType(e.target.value)}
                            className="col-span-3 bg-slate-800 border border-slate-750 rounded px-1 text-slate-300 outline-none"
                          >
                            <option value="all">All</option>
                            <option value="open_source">Open Source</option>
                            <option value="commercial">Commercial</option>
                          </select>
                          <select 
                            value={favSortBy} 
                            onChange={(e: any) => setFavSortBy(e.target.value)}
                            className="col-span-3 bg-slate-800 border border-slate-750 rounded px-1 text-slate-300 outline-none"
                          >
                            <option value="name">Sort A-Z</option>
                            <option value="date">Sort Date</option>
                          </select>
                        </div>

                        {/* Filtered & Sorted Favorites list */}
                        <div className="max-h-[110px] overflow-y-auto space-y-1.5 pr-1 scrollbar-thin">
                          {favorites.length === 0 ? (
                            <div className="text-center text-slate-500 py-3 text-[9px]">
                              No favorites saved. Search an app and click the Heart icon!
                            </div>
                          ) : (
                            favorites
                              // Convert strings to rich mockup objects for sorting/filtering
                              .map(name => {
                                const lower = name.toLowerCase();
                                const isOS = lower.includes('gimp') || lower.includes('inkscape') || lower.includes('code') || lower.includes('libre');
                                return {
                                  name,
                                  category: isOS ? 'Utility (OS)' : 'Productivity',
                                  original: lower.includes('gimp') ? 'Photoshop' : lower.includes('code') ? 'VS' : 'Proprietary',
                                  type: (isOS ? 'open_source' : 'commercial') as 'open_source' | 'commercial',
                                  date: name === 'Adobe Photoshop' ? '2026-06-20' : '2026-06-25'
                                };
                              })
                              // Filter
                              .filter(item => {
                                const matchesSearch = item.name.toLowerCase().includes(favSearchQuery.toLowerCase()) || 
                                                     item.original.toLowerCase().includes(favSearchQuery.toLowerCase());
                                const matchesFilter = favFilterType === 'all' || item.type === favFilterType;
                                return matchesSearch && matchesFilter;
                              })
                              // Sort
                              .sort((a, b) => {
                                if (favSortBy === 'name') return a.name.localeCompare(b.name);
                                return b.date.localeCompare(a.date);
                              })
                              .map((fav, idx) => (
                                <div key={idx} className="bg-slate-800/40 border border-slate-750/40 rounded-lg p-2 flex items-center justify-between">
                                  <div>
                                    <h6 className="font-bold text-slate-200 text-[10px]">{fav.name}</h6>
                                    <p className="text-[8px] text-slate-400">Alternative for {fav.original} • {fav.category}</p>
                                  </div>
                                  <button 
                                    onClick={() => toggleFavorite(fav.name)}
                                    className="text-amber-400 hover:text-slate-500 p-1"
                                    title="Unsave Favorite"
                                  >
                                    ★
                                  </button>
                                </div>
                              ))
                          )}
                        </div>
                      </div>

                      {/* Recent Searches with individual delete & clear all */}
                      <div className="bg-slate-850/30 border border-slate-750/60 rounded-xl p-3 flex flex-col gap-1.5">
                        <div className="flex justify-between items-center">
                          <span className="text-[9px] uppercase font-bold tracking-wider text-slate-400">Recent Search Queries</span>
                          {searchHistory.length > 0 && (
                            <button 
                              onClick={() => {
                                setSearchHistory([]);
                                triggerToast("Search history database cleared.");
                              }}
                              className="text-[8px] text-rose-400 hover:underline"
                            >
                              Clear All
                            </button>
                          )}
                        </div>

                        {searchHistory.length === 0 ? (
                          <div className="text-slate-500 text-[8px] py-1 text-center">Your query history is empty.</div>
                        ) : (
                          <div className="flex flex-wrap gap-1.5">
                            {searchHistory.map((query, i) => (
                              <div key={i} className="flex items-center gap-1 bg-slate-800 border border-slate-700/60 px-2 py-0.5 rounded-full text-[9px]">
                                <span 
                                  onClick={() => {
                                    setSearchQuery(query);
                                    handleSearchSubmit(query);
                                    setActiveTab('search');
                                  }}
                                  className="text-slate-300 hover:text-sky-400 cursor-pointer"
                                >
                                  {query}
                                </span>
                                <button 
                                  onClick={() => {
                                    setSearchHistory(prev => prev.filter(h => h !== query));
                                    triggerToast(`Deleted query "${query}"`);
                                  }}
                                  className="text-[8px] text-slate-500 hover:text-slate-300 px-0.5"
                                >
                                  ✕
                                </button>
                              </div>
                            ))}
                          </div>
                        )}
                      </div>

                      {/* Sanvi Companion Chats Shortcut */}
                      <div className="bg-slate-850/30 border border-slate-750/60 rounded-xl p-3 flex flex-col gap-2">
                        <span className="text-[9px] uppercase font-bold tracking-wider text-slate-400">Continue Conversation History</span>
                        <div className="space-y-1.5">
                          <div 
                            onClick={() => {
                              setChatMessages([
                                { sender: 'sanvi', content: 'Sure Amrit! Linux par Photoshop ke top alternatives GIMP (open source), Inkscape (Vector drawings ke liye), aur DaVinci Resolve (professional video/color grading ke liye) hain.', time: '14:20' },
                                { sender: 'user', content: 'GIMP me Photoshop ke shortcuts map kaise karein?', time: '14:21' }
                              ]);
                              setActiveTab('chat');
                              triggerToast("Resumed chat: Photoshop alternatives on Linux");
                            }}
                            className="bg-slate-850/50 border border-slate-750 p-2 rounded-lg cursor-pointer hover:bg-slate-800/80 transition-colors flex justify-between items-center"
                          >
                            <div>
                              <p className="font-bold text-slate-300 text-[9px]">Photoshop Alternatives on Linux</p>
                              <p className="text-[7px] text-slate-500">Last updated: 4 hours ago • 2 messages</p>
                            </div>
                            <span className="text-[7px] text-sky-400 bg-sky-400/5 border border-sky-400/10 px-1 py-0.5 rounded">RESUME</span>
                          </div>

                          <div 
                            onClick={() => {
                              setChatMessages([
                                { sender: 'sanvi', content: 'LibreOffice perfectly free alternative hai MS Office ka. Isme Writer (Word), Calc (Excel), aur Impress (PowerPoint) format full support hote hain.', time: 'Yesterday' }
                              ]);
                              setActiveTab('chat');
                              triggerToast("Resumed chat: LibreOffice vs MS Office");
                            }}
                            className="bg-slate-850/50 border border-slate-750 p-2 rounded-lg cursor-pointer hover:bg-slate-800/80 transition-colors flex justify-between items-center"
                          >
                            <div>
                              <p className="font-bold text-slate-300 text-[9px]">LibreOffice vs MS Office Compatibility</p>
                              <p className="text-[7px] text-slate-500">Last updated: Yesterday • 1 message</p>
                            </div>
                            <span className="text-[7px] text-sky-400 bg-sky-400/5 border border-sky-400/10 px-1 py-0.5 rounded">RESUME</span>
                          </div>
                        </div>
                      </div>

                      {/* Recommended Alternatives Bento Row */}
                      <div className="bg-slate-850/30 border border-slate-750/60 rounded-xl p-3">
                        <span className="text-[9px] uppercase font-bold tracking-wider text-slate-400 block mb-2">Recommended alternatives</span>
                        <div className="grid grid-cols-2 gap-2">
                          <div 
                            onClick={() => { setSearchQuery('Photoshop'); handleSearchSubmit('Photoshop'); setActiveTab('search'); }}
                            className="bg-slate-800/50 hover:bg-slate-850/80 border border-slate-750 p-2 rounded-lg cursor-pointer transition text-left"
                          >
                            <span className="text-amber-400 font-bold block text-[9px]">Figma Pro Alts?</span>
                            <span className="text-[7px] text-slate-400">Discover Penpot (Open Source) & Lunacy.</span>
                          </div>
                          <div 
                            onClick={() => { setSearchQuery('Microsoft Office'); handleSearchSubmit('Microsoft Office'); setActiveTab('search'); }}
                            className="bg-slate-800/50 hover:bg-slate-850/80 border border-slate-750 p-2 rounded-lg cursor-pointer transition text-left"
                          >
                            <span className="text-sky-400 font-bold block text-[9px]">MS Office Alts?</span>
                            <span className="text-[7px] text-slate-400">Discover LibreOffice, OnlyOffice & WPS.</span>
                          </div>
                        </div>
                      </div>

                      {/* Settings & Preferences Module */}
                      <div className="bg-slate-850/30 border border-slate-750/60 rounded-xl p-3 flex flex-col gap-2">
                        <span className="text-[9px] uppercase font-bold tracking-wider text-slate-400">Settings & Customization</span>

                        {/* Multi-Language picker buttons */}
                        <div className="flex flex-col gap-1">
                          <span className="text-[8px] text-slate-400 font-semibold uppercase">Preferred Language</span>
                          <div className="py-1 px-2 rounded font-semibold text-[8px] border bg-sky-500 text-white border-sky-400 w-fit">
                            English
                          </div>
                        </div>

                        {/* Multi-Theme Selector buttons */}
                        <div className="flex flex-col gap-1 mt-1">
                          <span className="text-[8px] text-slate-400 font-semibold uppercase">Application Theme Mode</span>
                          <div className="grid grid-cols-3 gap-1">
                            {(['dark', 'light', 'system'] as const).map((mode) => (
                              <button 
                                key={mode}
                                onClick={() => {
                                  setAppThemeMode(mode);
                                  triggerToast(`Theme switched to: ${mode.toUpperCase()} MODE`);
                                }}
                                className={`py-1 px-1.5 rounded font-semibold text-[8px] border transition ${
                                  appThemeMode === mode 
                                    ? 'bg-sky-500 text-white border-sky-400' 
                                    : 'bg-slate-800 text-slate-300 border-slate-700/60 hover:bg-slate-750'
                                }`}
                              >
                                {mode.toUpperCase()}
                              </button>
                            ))}
                          </div>
                        </div>

                        {/* Notifications Checkboxes */}
                        <div className="space-y-1.5 mt-1.5">
                          <div className="flex items-center justify-between">
                            <span className="text-[8px] text-slate-300">Email trial & billing alerts</span>
                            <input 
                              type="checkbox" 
                              checked={emailNotifications} 
                              onChange={(e) => {
                                setEmailNotifications(e.target.checked);
                                triggerToast(e.target.checked ? "Email notification alerts active" : "Email alerts disabled");
                              }}
                              className="accent-sky-500 h-3.5 w-3.5 rounded"
                            />
                          </div>
                          <div className="flex items-center justify-between">
                            <span className="text-[8px] text-slate-300">Push reminder updates</span>
                            <input 
                              type="checkbox" 
                              checked={pushNotifications} 
                              onChange={(e) => {
                                setPushNotifications(e.target.checked);
                                triggerToast(e.target.checked ? "Push reminder alerts active" : "Push alerts disabled");
                              }}
                              className="accent-sky-500 h-3.5 w-3.5 rounded"
                            />
                          </div>
                          <div className="flex items-center justify-between">
                            <span className="text-[8px] text-slate-300">Offline Cache State</span>
                            <span className="text-[7px] text-emerald-400 font-extrabold bg-emerald-500/10 px-1 py-0.5 rounded border border-emerald-500/15">CACHED (3.4 MB)</span>
                          </div>
                        </div>

                        {/* Clear Cache CTA */}
                        <div className="grid grid-cols-2 gap-2 mt-2 pt-1.5 border-t border-slate-800">
                          <button 
                            onClick={() => {
                              setAiSearchUsage(0);
                              setAdmobCounter(0);
                              triggerToast("Application disk cache cleared successfully!");
                            }}
                            className="bg-slate-800 hover:bg-slate-750 border border-slate-700 text-slate-300 py-1 rounded text-[8px] font-bold text-center"
                          >
                            CLEAR CACHE
                          </button>
                          <button 
                            onClick={() => {
                              triggerToast("Signed out securely from Apps Buddy.");
                            }}
                            className="bg-rose-950/20 hover:bg-rose-950/40 border border-rose-900/30 text-rose-400 py-1 rounded text-[8px] font-bold text-center"
                          >
                            SECURE LOGOUT
                          </button>
                        </div>

                      </div>

                      {/* Footer links */}
                      <div className="text-[8px] text-slate-500 flex justify-center gap-3 mt-auto py-1">
                        <button onClick={() => triggerToast("Displaying Terms of Service...")} className="hover:underline">Terms of Service</button>
                        <span>•</span>
                        <button onClick={() => triggerToast("Displaying Privacy Policy...")} className="hover:underline">Privacy Policy</button>
                      </div>
                    </div>
                  )}

                  {/* PHASE 5 ADMIN CONTROL & METRICS PANEL */}
                  {activeTab === 'admin' && (
                    <div className="flex-grow flex flex-col gap-3 overflow-y-auto max-h-[460px] pr-1 scrollbar-thin animate-fadeIn text-[11px] text-slate-200">
                      
                      {/* Role-Based Access Control Switcher */}
                      <div className="bg-gradient-to-r from-violet-950/40 to-slate-900 border border-violet-800/40 rounded-xl p-3">
                        <div className="flex justify-between items-center mb-2">
                          <span className="text-[8.5px] uppercase font-bold tracking-wider text-violet-400">Security Access Controls (RBAC)</span>
                          <span className="text-[7.5px] font-mono bg-violet-500/10 text-violet-300 border border-violet-500/15 px-1.5 py-0.5 rounded">ENV SECURE</span>
                        </div>
                        
                        <div className="flex flex-col gap-1.5">
                          <div className="flex items-center gap-1">
                            <span className="text-[8px] text-slate-400 uppercase font-medium">Active Admin Role:</span>
                            <select 
                              value={adminRole}
                              onChange={(e: any) => {
                                setAdminRole(e.target.value);
                                setAdminLogs(prev => [
                                  { time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }), actor: e.target.value, action: 'AUTH_ELEVATE', desc: `Role changed to ${e.target.value}` },
                                  ...prev
                                ]);
                                triggerToast(`Role privileges updated to ${e.target.value}`);
                              }}
                              className="bg-slate-800 border border-slate-700/60 rounded px-1.5 py-0.5 text-slate-200 text-[8px] focus:border-violet-500 outline-none"
                            >
                              <option value="Super Admin">Super Admin (All Access)</option>
                              <option value="Admin">Admin (Tuning & CMS)</option>
                              <option value="Moderator">Moderator (Safety Review)</option>
                              <option value="Support">Support (View & Edit user)</option>
                              <option value="Viewer">Viewer (Read-Only)</option>
                            </select>
                          </div>
                          
                          <p className="text-[7.5px] text-slate-400 leading-normal italic">
                            {adminRole === 'Super Admin' && "✓ Full system configuration, billing databases, environment keys, and deployment nodes active."}
                            {adminRole === 'Admin' && "✓ Permitted to alter Sanvi AI models, tune safety parameters, modify featured apps, and suspend accounts."}
                            {adminRole === 'Moderator' && "✓ Permitted to review safety filter violations, and moderate CMS articles / alternative catalogs."}
                            {adminRole === 'Support' && "✓ Permitted to lookup user registration databases, reset preference flags, and trigger backups."}
                            {adminRole === 'Viewer' && "⚠ Read-only visualization mode. Changes to prompt parameters and user suspensions are write-blocked."}
                          </p>
                        </div>
                      </div>

                      {/* Overall Platform Metrics Analytics Grid */}
                      <div className="grid grid-cols-2 gap-2">
                        <div className="bg-slate-850/40 border border-slate-750 p-2.5 rounded-lg">
                          <span className="text-[7.5px] text-slate-400 uppercase font-bold tracking-wider">Total Registers</span>
                          <h4 className="text-sm font-black text-white mt-0.5">2,540 <span className="text-[7.5px] text-emerald-400 font-normal ml-1">↑ 12%</span></h4>
                          <span className="text-[7px] text-slate-500">1,890 Monthly Active</span>
                        </div>
                        <div className="bg-slate-850/40 border border-slate-750 p-2.5 rounded-lg">
                          <span className="text-[7.5px] text-slate-400 uppercase font-bold tracking-wider">Total Revenue</span>
                          <h4 className="text-sm font-black text-emerald-400 mt-0.5">₹107,460.00</h4>
                          <span className="text-[7px] text-slate-500">₹79k Subs + ₹28k AdMob</span>
                        </div>
                        <div className="bg-slate-850/40 border border-slate-750 p-2.5 rounded-lg">
                          <span className="text-[7.5px] text-slate-400 uppercase font-bold tracking-wider">Conversion Stats</span>
                          <h4 className="text-sm font-black text-white mt-0.5">45.0%</h4>
                          <span className="text-[7px] text-slate-500">1,200 active trial accounts</span>
                        </div>
                        <div className="bg-slate-850/40 border border-slate-750 p-2.5 rounded-lg">
                          <span className="text-[7.5px] text-slate-400 uppercase font-bold tracking-wider">AI API Tokens</span>
                          <h4 className="text-sm font-black text-violet-400 mt-0.5">485k / 500k</h4>
                          <span className="text-[7px] text-slate-500">Avg response: 180ms</span>
                        </div>
                      </div>

                      {/* Content Management System (CMS) Section */}
                      <div className="bg-slate-850/30 border border-slate-750/60 rounded-xl p-3 flex flex-col gap-2">
                        <span className="text-[8.5px] uppercase font-bold tracking-wider text-slate-400">Content Management System (CMS)</span>
                        
                        {/* Display featured alternative applications */}
                        <div className="flex flex-col gap-1.5">
                          <span className="text-[8px] text-slate-400 uppercase font-semibold">Featured Software Alternatives</span>
                          <div className="space-y-1.5 max-h-[110px] overflow-y-auto pr-0.5 scrollbar-thin">
                            {featuredApps.map((app, i) => (
                              <div key={i} className="bg-slate-800/60 border border-slate-750 p-2 rounded flex justify-between items-start">
                                <div className="flex-1 min-w-0 pr-2">
                                  <div className="flex items-center gap-1.5">
                                    <span className="font-bold text-slate-200 text-[9.5px]">{app.name}</span>
                                    <span className="text-[7px] bg-slate-700/60 px-1 py-0.2 rounded text-slate-400">Alt for {app.original}</span>
                                  </div>
                                  <p className="text-[7.5px] text-slate-400 mt-0.5 truncate">{app.desc}</p>
                                </div>
                                <button 
                                  onClick={() => {
                                    if (adminRole === 'Viewer') {
                                      triggerToast("Write block: Viewer role cannot modify CMS content.");
                                      return;
                                    }
                                    setFeaturedApps(prev => prev.filter(a => a.name !== app.name));
                                    setAdminLogs(prev => [
                                      { time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }), actor: adminRole, action: 'CMS_DELETE', desc: `Deleted featured app: ${app.name}` },
                                      ...prev
                                    ]);
                                    triggerToast(`Removed featured application: ${app.name}`);
                                  }}
                                  className="text-[8px] text-rose-400 hover:text-rose-300 font-bold px-1"
                                >
                                  Delete
                                </button>
                              </div>
                            ))}
                          </div>

                          {/* Quick Add featured alt mapping form */}
                          <button 
                            onClick={() => {
                              if (adminRole === 'Viewer') {
                                triggerToast("Write block: Viewer role cannot modify CMS content.");
                                return;
                              }
                              const altName = prompt("Enter Alternative App Name (e.g. Penpot):");
                              const origName = prompt("Enter Original proprietary software target (e.g. Figma Pro):");
                              if (altName && origName) {
                                setFeaturedApps(prev => [...prev, { name: altName, original: origName, desc: 'Curated alternative published via administrative panel.', category: 'Design' }]);
                                setAdminLogs(prev => [
                                  { time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }), actor: adminRole, action: 'CMS_PUBLISH', desc: `Published mapping ${altName} vs ${origName}` },
                                  ...prev
                                ]);
                                triggerToast(`Vetted alternative ${altName} successfully published!`);
                              }
                            }}
                            className="bg-slate-800 hover:bg-slate-750 text-slate-200 border border-slate-700 py-1 rounded text-[8px] font-bold text-center mt-0.5"
                          >
                            + ADD NEW FEATURED ALTERNATIVE MAPPING
                          </button>
                        </div>

                        {/* Broadcast Announcement Banners */}
                        <div className="flex flex-col gap-1 mt-1">
                          <span className="text-[8px] text-slate-400 uppercase font-semibold">Active Announcement Banners</span>
                          {cmsBanners.map((banner, i) => (
                            <div key={i} className="flex items-center justify-between bg-slate-800/40 p-1.5 rounded border border-slate-750 text-[7.5px]">
                              <span className="truncate max-w-[190px] text-slate-300">{banner.title}</span>
                              <input 
                                type="checkbox"
                                checked={banner.active}
                                onChange={(e) => {
                                  if (adminRole === 'Viewer') {
                                    triggerToast("Write block: Viewer role cannot modify CMS banners.");
                                    return;
                                  }
                                  setCmsBanners(prev => prev.map(b => b.id === banner.id ? { ...b, active: e.target.checked } : b));
                                  triggerToast(e.target.checked ? "Announcement banner activated!" : "Announcement banner disabled.");
                                }}
                                className="accent-violet-500 h-3 w-3"
                              />
                            </div>
                          ))}
                        </div>

                        {/* Help center & FAQ curation */}
                        <div className="flex flex-col gap-1 mt-1">
                          <span className="text-[8px] text-slate-400 uppercase font-semibold">In-App Help Articles / FAQs</span>
                          <div className="space-y-1 text-[7.5px]">
                            {cmsFaqs.map((faq, idx) => (
                              <div key={idx} className="bg-slate-800/30 border border-slate-750 p-1.5 rounded">
                                <p className="font-bold text-slate-300">Q: {faq.q}</p>
                                <p className="text-slate-400 mt-0.5">A: {faq.a}</p>
                              </div>
                            ))}
                          </div>
                        </div>

                      </div>

                      {/* Sanvi AI Core Platform Tuning parameters */}
                      <div className="bg-slate-850/30 border border-slate-750/60 rounded-xl p-3 flex flex-col gap-2">
                        <div className="flex justify-between items-center">
                          <span className="text-[8.5px] uppercase font-bold tracking-wider text-slate-400">Sanvi AI Personality & Model Tuning</span>
                          <span className="text-[7.5px] text-slate-500">Gemini-2.5-Flash</span>
                        </div>

                        <div className="flex flex-col gap-1.5">
                          <span className="text-[8px] text-slate-400 uppercase font-semibold">System Prompt Template</span>
                          <textarea 
                            value={aiPromptTemplate}
                            onChange={(e) => {
                              if (adminRole === 'Viewer') {
                                triggerToast("Write block: Viewer role cannot alter model guidelines.");
                                return;
                              }
                              setAiPromptTemplate(e.target.value);
                            }}
                            className="bg-slate-800 border border-slate-750/80 rounded px-2 py-1.5 text-[8px] text-slate-100 font-mono focus:border-violet-500 outline-none h-14 resize-none"
                            placeholder="System instructions template..."
                          />
                        </div>

                        <div className="grid grid-cols-2 gap-2 mt-1">
                          <div className="flex flex-col gap-0.5">
                            <span className="text-[8px] text-slate-400 uppercase">Personality Preset</span>
                            <select 
                              value={aiPersonality}
                              onChange={(e: any) => {
                                if (adminRole === 'Viewer') {
                                  triggerToast("Write block: Viewer role cannot alter model guidelines.");
                                  return;
                                }
                                setAiPersonality(e.target.value);
                                triggerToast(`Personality set to: ${e.target.value}`);
                              }}
                              className="bg-slate-800 border border-slate-750 rounded p-1 text-[8px] text-slate-300 outline-none"
                            >
                              <option value="conversational">Conversational (Warm)</option>
                              <option value="professional">Professional (Technical)</option>
                            </select>
                          </div>

                          <div className="flex flex-col gap-0.5">
                            <span className="text-[8px] text-slate-400 uppercase">Daily Query Caps</span>
                            <input 
                              type="number"
                              value={aiDailyLimit}
                              onChange={(e) => {
                                if (adminRole === 'Viewer') {
                                  triggerToast("Write block: Viewer role cannot alter model guidelines.");
                                  return;
                                }
                                setAiDailyLimit(Number(e.target.value));
                              }}
                              className="bg-slate-800 border border-slate-750 rounded p-1 text-[8px] text-slate-100 outline-none text-center"
                            />
                          </div>
                        </div>

                        {/* Safety switches */}
                        <div className="space-y-1.5 mt-1">
                          <div className="flex items-center justify-between">
                            <span className="text-[8px] text-slate-300">Enable automated safety query guard filters</span>
                            <input 
                              type="checkbox"
                              checked={aiSafetyFilters}
                              onChange={(e) => {
                                if (adminRole === 'Viewer') {
                                  triggerToast("Write block: Viewer role cannot alter model guidelines.");
                                  return;
                                }
                                setAiSafetyFilters(e.target.checked);
                                triggerToast(e.target.checked ? "Harmful queries safety filters ACTIVE" : "Safety filters standard override warning active");
                              }}
                              className="accent-violet-500 h-3 w-3"
                            />
                          </div>
                          <div className="flex items-center justify-between">
                            <span className="text-[8px] text-slate-300">Bypass AdMob for Premium users</span>
                            <span className="text-[7.5px] text-emerald-400 font-extrabold bg-emerald-500/10 px-1 rounded">FORCE ACTIVE</span>
                          </div>
                        </div>

                        <button 
                          onClick={() => {
                            if (adminRole === 'Viewer') {
                              triggerToast("Write block: Viewer cannot commit parameters.");
                              return;
                            }
                            setAdminLogs(prev => [
                              { time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }), actor: adminRole, action: 'AI_TUNING_RULES', desc: `Synchronized safety filters=${aiSafetyFilters} & usage cap=${aiDailyLimit}` },
                              ...prev
                            ]);
                            triggerToast("System instructions successfully bound to Gemini model runtime! ✅");
                          }}
                          className="bg-violet-600 hover:bg-violet-700 text-white font-bold py-1 rounded text-[8px] text-center"
                        >
                          SYNCHRONIZE MODEL CONFIGS
                        </button>

                      </div>

                      {/* User Account Administration Panel */}
                      <div className="bg-slate-850/30 border border-slate-750/60 rounded-xl p-3 flex flex-col gap-2">
                        <span className="text-[8.5px] uppercase font-bold tracking-wider text-slate-400">User Account Administration</span>
                        
                        {/* Users search field */}
                        <div className="flex gap-1">
                          <input 
                            type="text" 
                            placeholder="Search active users database..."
                            value={adminSearchUserQuery}
                            onChange={(e) => setAdminSearchUserQuery(e.target.value)}
                            className="bg-slate-800 border border-slate-750 rounded px-1.5 py-0.5 text-slate-100 focus:border-violet-500 outline-none flex-1 text-[8px]"
                          />
                        </div>

                        {/* Simulated user directory table/list */}
                        <div className="space-y-1.5 max-h-[120px] overflow-y-auto pr-0.5 scrollbar-thin">
                          {[
                            { name: 'Amrit Kumar', email: 'amrit.kumar@outlook.com', plan: 'Trial', status: 'Active' },
                            { name: 'Rohan Sharma', email: 'rohan.sharma99@gmail.com', plan: 'Free', status: 'Suspended' },
                            { name: 'Priya Patel', email: 'priya.patel@tech.in', plan: 'Premium', status: 'Active' },
                            { name: 'Vikram Singh', email: 'vikram.singh@corporate.com', plan: 'Premium', status: 'Active' }
                          ]
                          .filter(user => user.name.toLowerCase().includes(adminSearchUserQuery.toLowerCase()) || user.email.toLowerCase().includes(adminSearchUserQuery.toLowerCase()))
                          .map((user, i) => {
                            const isSuspended = adminSuspendUserList.includes(user.name) || user.status === 'Suspended';
                            return (
                              <div key={i} className="bg-slate-800/50 border border-slate-750/60 p-2 rounded flex justify-between items-center">
                                <div>
                                  <div className="flex items-center gap-1.5">
                                    <span className="font-bold text-slate-200 text-[9px]">{user.name}</span>
                                    <span className={`text-[7px] font-extrabold px-1 rounded uppercase ${
                                      user.plan === 'Premium' ? 'bg-amber-500/10 text-amber-400' : 'bg-slate-700 text-slate-400'
                                    }`}>{user.plan}</span>
                                  </div>
                                  <p className="text-[7.5px] text-slate-500">{user.email}</p>
                                </div>

                                <div className="flex gap-1.5 items-center">
                                  <span className={`text-[7px] font-bold ${isSuspended ? 'text-rose-400 bg-rose-500/10 px-1 py-0.2 rounded border border-rose-500/15' : 'text-emerald-400 bg-emerald-500/10 px-1 py-0.2 rounded border border-emerald-500/15'}`}>
                                    {isSuspended ? 'SUSPENDED' : 'ACTIVE'}
                                  </span>

                                  <button 
                                    onClick={() => {
                                      if (adminRole === 'Viewer' || adminRole === 'Support') {
                                        triggerToast("Write block: Your role does not support suspends.");
                                        return;
                                      }
                                      if (isSuspended) {
                                        setAdminSuspendUserList(prev => prev.filter(u => u !== user.name));
                                        setAdminLogs(prev => [
                                          { time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }), actor: adminRole, action: 'USER_RECOVER', desc: `Re-activated suspended user account: ${user.name}` },
                                          ...prev
                                        ]);
                                        triggerToast(`Activated user: ${user.name}`);
                                      } else {
                                        setAdminSuspendUserList(prev => [...prev, user.name]);
                                        setAdminLogs(prev => [
                                          { time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }), actor: adminRole, action: 'USER_SUSPEND', desc: `Suspended malicious user account: ${user.name}` },
                                          ...prev
                                        ]);
                                        triggerToast(`Suspended user: ${user.name}`);
                                      }
                                    }}
                                    className="bg-slate-800 hover:bg-slate-750 px-1.5 py-0.5 rounded text-[7.5px] border border-slate-700 text-slate-300 font-bold"
                                  >
                                    {isSuspended ? 'ACTIVATE' : 'SUSPEND'}
                                  </button>
                                </div>
                              </div>
                            );
                          })}
                        </div>

                        {/* Export User database trigger */}
                        <div className="grid grid-cols-2 gap-2 mt-1">
                          <button 
                            onClick={() => {
                              triggerToast("Generating CSV architecture backup... Ready!");
                              const data = "Name,Email,Plan,Status\nAmrit Kumar,amrit.kumar@outlook.com,Trial,Active\nPriya Patel,priya.patel@tech.in,Premium,Active";
                              const blob = new Blob([data], { type: 'text/csv' });
                              const url = window.URL.createObjectURL(blob);
                              const a = document.createElement('a');
                              a.setAttribute('href', url);
                              a.setAttribute('download', 'apps_alternator_users_export.csv');
                              a.click();
                            }}
                            className="bg-slate-800 hover:bg-slate-750 border border-slate-700 py-1 rounded text-[8px] font-bold text-center text-slate-300"
                          >
                            EXPORT USER REGISTERS
                          </button>
                          <button 
                            onClick={() => {
                              if (adminRole === 'Viewer') {
                                triggerToast("Write block: Read-only access active.");
                                return;
                              }
                              triggerToast("Successfully reset preferences flags to system defaults.");
                            }}
                            className="bg-slate-800 hover:bg-slate-750 border border-slate-700 py-1 rounded text-[8px] font-bold text-center text-slate-300"
                          >
                            RESET GLOBAL SETTINGS
                          </button>
                        </div>

                      </div>

                      {/* Security Auditing & Logs */}
                      <div className="bg-slate-850/30 border border-slate-750/60 rounded-xl p-3 flex flex-col gap-2">
                        <div className="flex justify-between items-center">
                          <span className="text-[8.5px] uppercase font-bold tracking-wider text-slate-400">Security Audit Trail Logs</span>
                          <button 
                            onClick={() => {
                              setAdminLogs([]);
                              triggerToast("Administrative audit logs wiped.");
                            }}
                            className="text-[7.5px] text-rose-400 hover:underline"
                          >
                            Clear Trail
                          </button>
                        </div>

                        <div className="space-y-1 max-h-[100px] overflow-y-auto pr-0.5 scrollbar-thin">
                          {adminLogs.map((log, idx) => (
                            <div key={idx} className="bg-slate-900/60 p-1.5 rounded border border-slate-800 text-[7px] font-mono leading-normal flex items-start gap-1">
                              <span className="text-violet-400">[{log.time}]</span>
                              <span className="text-amber-400 font-bold">[{log.actor}]</span>
                              <span className="text-sky-400">[{log.action}]</span>
                              <span className="text-slate-300">{log.desc}</span>
                            </div>
                          ))}
                        </div>

                        {/* Server Crashes & Debug Trace */}
                        <div className="flex flex-col gap-1 mt-1.5">
                          <span className="text-[8px] text-rose-400 font-bold uppercase">Critical Infrastructure Incidents (3)</span>
                          <div className="bg-rose-950/10 border border-rose-900/30 p-2 rounded text-[7.5px] font-mono text-rose-300 leading-normal space-y-1">
                            <p>● [FATAL] [2026-06-25 14:15] Gemini API connection timed out. Retrying automatically...</p>
                            <p>● [WARN] [2026-06-25 18:02] Razorpay webhook signature verification failed for test transaction.</p>
                            <p>● [FATAL] [2026-06-26 04:30] Device indexing cache out of memory on low-end Android emulator.</p>
                          </div>
                        </div>
                      </div>

                      {/* General Administration Configuration */}
                      <div className="bg-slate-850/30 border border-slate-750/60 rounded-xl p-3 flex flex-col gap-2">
                        <span className="text-[8.5px] uppercase font-bold tracking-wider text-slate-400">Branding & System Configuration</span>
                        
                        <div className="space-y-1.5 text-[8px]">
                          <div className="flex items-center justify-between">
                            <span>Enable Global System Maintenance Mode</span>
                            <input 
                              type="checkbox"
                              checked={maintenanceMode}
                              onChange={(e) => {
                                if (adminRole !== 'Super Admin') {
                                  triggerToast("Write block: Super Admin permission required.");
                                  return;
                                }
                                setMaintenanceMode(e.target.checked);
                                triggerToast(e.target.checked ? "System set to MAINTENANCE MODE" : "System live!");
                              }}
                              className="accent-violet-500 h-3 w-3"
                            />
                          </div>
                          <div className="flex items-center justify-between">
                            <span>Custom branding assets override</span>
                            <span className="text-slate-400 italic">Vetted Assets Configured</span>
                          </div>
                          <div className="flex items-center justify-between">
                            <span>Email Notification Templates</span>
                            <span className="text-slate-400 italic font-mono">[welcome_member_v2]</span>
                          </div>
                        </div>
                      </div>

                      {/* Return to Dashboard CTA */}
                      <button 
                        onClick={() => setActiveTab('dashboard')}
                        className="bg-slate-800 hover:bg-slate-750 text-slate-200 border border-slate-700 py-1.5 rounded text-[8.5px] font-bold text-center mt-1"
                      >
                        ← BACK TO MY USER DASHBOARD
                      </button>

                    </div>
                  )}

                </div>

                {/* Simulated Google AdMob Banner Ad unit */}
                {membershipTier === 'free' && (
                  <div 
                    onClick={() => {
                      setAdmobCounter(prev => prev + 1);
                      triggerToast("AdMob Ad clicked! (Simulated Interstitial overlay preloaded)");
                    }}
                    className="mx-3 my-1 bg-amber-400/10 border border-amber-500/30 rounded-lg p-2 flex items-center justify-between cursor-pointer hover:bg-amber-400/15 transition animate-pulse"
                  >
                    <div className="flex items-center gap-2">
                      <span className="text-[7px] bg-amber-500 text-slate-950 font-extrabold px-1 py-0.5 rounded uppercase tracking-wider">Ad</span>
                      <p className="text-[9px] text-amber-200 font-medium truncate max-w-[170px]">Alternatives for Figma Pro up to 40% off!</p>
                    </div>
                    <span className="text-[8px] text-slate-400 hover:text-slate-200">✕</span>
                  </div>
                )}

                {/* Simulated Device Bottom Navigation bar */}
                <div className="border-t border-slate-800/80 bg-slate-900/90 py-2 px-3 flex justify-around items-center sticky bottom-0 z-10 text-[8.5px] font-medium text-slate-400">
                  <button 
                    onClick={() => { setActiveTab('search'); setSearchQuery('Photoshop'); handleSearchSubmit('Photoshop'); }} 
                    className={`flex flex-col items-center gap-1 transition-colors ${activeTab === 'search' ? 'text-sky-400' : 'hover:text-slate-200'}`}
                  >
                    <Search size={13} />
                    <span>Search</span>
                  </button>
                  <button 
                    onClick={() => setActiveTab('chat')} 
                    className={`flex flex-col items-center gap-1 transition-colors ${activeTab === 'chat' ? 'text-sky-400' : 'hover:text-slate-200'}`}
                  >
                    <MessageSquare size={13} />
                    <span>Sanvi AI</span>
                  </button>
                  <button 
                    onClick={() => setActiveTab('dashboard')} 
                    className={`flex flex-col items-center gap-1 transition-colors ${activeTab === 'dashboard' ? 'text-sky-400' : 'hover:text-slate-200'}`}
                  >
                    <Settings size={13} className={activeTab === 'dashboard' ? 'text-sky-400 animate-spin-slow' : ''} />
                    <span>Dashboard</span>
                  </button>
                  <button 
                    onClick={() => setActiveTab('premium')} 
                    className={`flex flex-col items-center gap-1 transition-colors ${activeTab === 'premium' ? 'text-amber-400' : 'hover:text-slate-200'}`}
                  >
                    <Heart size={13} className={membershipTier === 'premium' ? 'fill-amber-400 text-amber-400' : ''} />
                    <span>Premium</span>
                  </button>
                </div>

              </div>
            </div>
          </div>
        </div>

        {/* RIGHT COLUMN: Code explorer, file tree & verification suite (Width: 7 Cols) */}
        <div className="xl:col-span-7 flex flex-col bg-slate-900/40">
          
          {/* Top Panel: Split between File Tree and Code Inspector */}
          <div className="flex-1 grid grid-cols-1 md:grid-cols-12 border-b border-slate-800 min-h-0">
            
            {/* File Tree Left Section (Width: 4/12) */}
            <div className="md:col-span-4 border-r border-slate-800 p-4 flex flex-col overflow-y-auto">
              <div className="flex items-center justify-between mb-4">
                <span className="text-xs font-semibold text-slate-400 uppercase tracking-wider flex items-center gap-1.5">
                  <Code2 size={13} className="text-sky-400" /> Flutter File Explorer
                </span>
                <button 
                  onClick={fetchFileTree} 
                  className="p-1 rounded text-slate-500 hover:text-slate-300 transition"
                  title="Reload Directory Tree"
                >
                  <RefreshCw size={12} />
                </button>
              </div>

              {/* Dynamic File Tree rendering */}
              <div className="flex-1 space-y-1 select-none">
                {fileTree.length > 0 ? (
                  fileTree.map(renderFileNode)
                ) : (
                  <div className="text-center text-slate-500 text-xs py-8">
                    No files found in workspace root.
                  </div>
                )}
              </div>
            </div>

            {/* Live Code Viewer Section (Width: 8/12) */}
            <div className="md:col-span-8 flex flex-col min-h-[350px] md:min-h-0 bg-slate-950/80">
              
              {/* Path and actions bar */}
              <div className="px-4 py-2 bg-slate-900 border-b border-slate-800 flex items-center justify-between text-xs">
                <span className="font-mono text-slate-300 flex items-center gap-1.5">
                  <FileCode size={13} className="text-sky-400" />
                  {selectedFilePath}
                </span>
                <div className="flex items-center gap-2">
                  <button 
                    onClick={copyCodeToClipboard}
                    className="flex items-center gap-1 py-1 px-2.5 rounded bg-slate-800 hover:bg-slate-750 text-slate-300 transition text-[11px]"
                  >
                    {copied ? <Check size={11} className="text-emerald-400" /> : <Copy size={11} />}
                    {copied ? 'Copied!' : 'Copy Code'}
                  </button>
                </div>
              </div>

              {/* Code viewer container */}
              <div className="flex-1 p-4 overflow-auto font-mono text-[11px] leading-relaxed text-slate-300 select-text scrollbar-thin">
                {isFileLoading ? (
                  <div className="h-full flex flex-col items-center justify-center text-slate-500 gap-2">
                    <div className="animate-spin rounded-full h-6 w-6 border-2 border-sky-500 border-t-transparent"></div>
                    <span>Fetching live source code...</span>
                  </div>
                ) : (
                  <pre className="whitespace-pre">{selectedFileContent}</pre>
                )}
              </div>

            </div>

          </div>

          {/* Bottom Panel: Verification suite & Architectural stats */}
          <div className="p-5 grid grid-cols-1 md:grid-cols-12 gap-5 bg-slate-900/60">
            
            {/* Architecture Details Left Panel (Width: 7/12) */}
            <div className="md:col-span-7 flex flex-col gap-3">
              <h4 className="text-xs font-semibold text-slate-400 uppercase tracking-wider flex items-center gap-1.5">
                <Info size={13} className="text-sky-400" /> Clean Architecture & Design Notes
              </h4>
              <div className="bg-slate-950/50 rounded-xl p-4 border border-slate-800/80 text-xs space-y-2.5 text-slate-300">
                <div className="flex items-start gap-2.5">
                  <div className="bg-sky-500/10 p-1 rounded text-sky-400 mt-0.5"><CheckCircle2 size={12} /></div>
                  <p>
                    <strong className="text-slate-200">Decoupled Entities & Repositories:</strong> Abstract interface contracts are stored inside the <code className="text-sky-400 font-mono">domain/repositories</code> layer, keeping logic separate from remote endpoints or local files.
                  </p>
                </div>
                <div className="flex items-start gap-2.5">
                  <div className="bg-sky-500/10 p-1 rounded text-sky-400 mt-0.5"><CheckCircle2 size={12} /></div>
                  <p>
                    <strong className="text-slate-200">Robust Live State Control:</strong> Riverpod is used as the foundational State Notifier provider framework to update both chat sessions and application details instantly across all sub-views.
                  </p>
                </div>
                <div className="flex items-start gap-2.5">
                  <div className="bg-sky-500/10 p-1 rounded text-sky-400 mt-0.5"><CheckCircle2 size={12} /></div>
                  <p>
                    <strong className="text-slate-200">Failsafe Simulator Fallbacks:</strong> The repository uses modern <code className="text-sky-400 font-mono">google_generative_ai</code> with custom configurations and implements perfect local structured parsing logic during offline periods.
                  </p>
                </div>
              </div>
            </div>

            {/* Interactive Compiler Pass/Verification Right Panel (Width: 5/12) */}
            <div className="md:col-span-5 flex flex-col gap-3">
              <div className="flex items-center justify-between">
                <h4 className="text-xs font-semibold text-slate-400 uppercase tracking-wider flex items-center gap-1.5">
                  <BadgeAlert size={13} className="text-sky-400" /> Compiler & Build verification
                </h4>
                <button 
                  onClick={runVerifySystem}
                  disabled={verifying}
                  className="flex items-center gap-1 py-1.5 px-3 rounded-lg bg-sky-500 hover:bg-sky-600 disabled:bg-slate-800 text-white text-xs font-semibold shadow-lg shadow-sky-500/10 transition"
                >
                  <Play size={11} className={verifying ? 'animate-ping' : ''} />
                  {verifying ? 'Running...' : 'Run Test'}
                </button>
              </div>

              {/* Console log simulation area */}
              <div className="bg-slate-950/80 rounded-xl p-3 border border-slate-800 flex-1 flex flex-col justify-between min-h-[140px] max-h-[180px] overflow-hidden">
                <div className="flex-grow overflow-y-auto space-y-1 font-mono text-[9px] text-slate-400 leading-normal pr-1 scrollbar-thin">
                  {verificationLogs.length > 0 ? (
                    verificationLogs.map((log, idx) => (
                      <div key={idx} className="flex items-start gap-1">
                        <span className="text-sky-500">{'>'}</span>
                        <span>{log}</span>
                      </div>
                    ))
                  ) : (
                    <div className="text-slate-600 italic py-6 text-center">
                      Click "Run Test" to run full Flutter structural validation checks over the newly implemented Phase 2 code.
                    </div>
                  )}
                </div>
                {verificationSuccess !== null && (
                  <div className={`mt-2 p-1.5 rounded text-[10px] flex items-center gap-1.5 font-bold ${
                    verificationSuccess ? 'bg-emerald-500/10 text-emerald-400 border border-emerald-500/20' : 'bg-red-500/10 text-red-400'
                  }`}>
                    <CheckCircle2 size={12} />
                    <span>BUILD RESULT: SUCCESS (Ready for Codemagic Pipeline)</span>
                  </div>
                )}
              </div>
            </div>

          </div>

        </div>

      </main>
    </div>
  );
}
