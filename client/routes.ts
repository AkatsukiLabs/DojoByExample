import { Sidebar, SidebarItem } from "vocs";

const config: Sidebar = [
  {
    text: "Introduction",
    link: "/",
  },
  {
    text: "Getting Started",
    items: [
      {
        text: "Local environment setup",
        link: "/getting-started/env_setup",
      },
      {
        text: "Basics of Dojo",
        collapsed: true,
        items: [
          {
            text: "Models",
            link: "/getting-started/basics/models",
          },
          {
            text: "Enums",
            link: "/getting-started/basics/enums",
          },
          {
            text: "Systems",
            link: "/getting-started/basics/systems",
          },
          {
            text: "World",
            link: "/getting-started/basics/world",
          },
          {
            text: "Store",
            link: "/getting-started/basics/store",
          },
          {
            text: "Constants",
            link: "/getting-started/basics/constants",
          },
          {
            text: "Helpers",
            link: "/getting-started/basics/helpers",
          },
          {
            text: "Events",
            link: "/getting-started/basics/events",
          },
          {
            text: "Testing",
            items: [
              {
                text: "Unit Testing",
                link: "/getting-started/basics/testing/unit_testing",
              },
              {
                text: "Integration Testing",
                link: "/getting-started/basics/testing/integration_testing",
              },
            ],
          },
        ],
      },
    ],
  },
  {
    text: "Deployments",
    collapsed: true,
    items: [
      {
        text: "Katana",
        link: "/deployments/katana",
      },
      {
        text: "Slot",
        link: "/deployments/slot",
      },
      {
        text: "Sepolia",
        link: "/deployments/sepolia",
      },
      {
        text: "Mainnet",
        link: "/deployments/mainnet",
      },
    ],
  },
  {
    text: "Starters & Templates",
    collapsed: true,
    items: [
      {
        text: "Full Starter React",
        link: "/starters/full-react-starter",
      },
    ],
  },
  {
    text: "Applications",
    collapsed: true,
    items: [
      {
        text: "Cartridge Controller",
        link: "/applications/cartridge_controller",
      },
      {
        text: "ERC20 Token",
        link: "/applications/erc20",
      },
      {
        text: "ERC721 NFT",
        link: "/applications/erc721",
      },
    ],
  },
  {
    text: "Advanced concepts",
    collapsed: true,
    items: [
      {
        text: "Gas Optimization",
        link: "/advanced-concepts/gas_optimizations",
      },
      {
        text: "Traditional Smart Contracts vs Dojo Contracts",
        link: "/advanced-concepts/contracts",
      },
    ],
  },
  {
    text: "Dojo Integrations",
    collapsed: true,
    items: [
      {
        text: "React",
        link: "/integrations/react",
      },
      {
        text: "Unity",
        link: "/integrations/unity",
      },
      {
        text: "AI Agents",
        items: [
          {
            text: "Daydreams",
            link: "/integrations/ai/daydreams",
          },
          {
            text: "Eliza",
            link: "/integrations/ai/eliza",
          },
        ],
      },
    ],
  },
  {
    text: "Dojo Use Cases",
    collapsed: true,
    items: [],
  },
  {
    text: "Dojo Best Practices",
    collapsed: true,
    items: [],
  },
];

/**
 * Gets all top-level routes from the sidebar config
 * @param sidebar
 * @returns Array of route paths and their corresponding section names
 */
const getTopLevelRoutes = (sidebar: SidebarItem[]): Array<[string, string]> =>
  sidebar
    .filter((item) => item.text !== "Introduction") // Skip Introduction
    .map((item) => {
      // Convert the text to a URL-friendly format and get the first link if available
      const path =
        item.link || `/${item.text.toLowerCase().replace(/\s+/g, "-")}`;
      return [path.split("/")[1], item.text] as [string, string];
    });

/**
 * Generates a complete sidebar configuration with automatic route-based collapsing
 * @param sidebar
 * @returns Complete sidebar configuration object with route-specific collapsed states
 */
const generateSidebarConfig = (sidebar: SidebarItem[]): Sidebar => {
  // Initialize with the default route
  const config: Sidebar = {
    "/": sidebar,
  };

  // Configure for all top-level routes
  getTopLevelRoutes(sidebar).forEach(([route, sectionName]) => {
    config[`/${route}`] = sidebarFocusOn(sidebar, sectionName, true);
  });

  return config;
};

/**
 * Recursively modifies the sidebar structure to control which sections are collapsed
 * @param sidebar - The original sidebar configuration array
 * @param target - The section text to keep expanded (uncollapsed)
 * @param closeOther - Whether to force collapse all non-target sections
 * @returns Modified sidebar array with controlled collapsed states
 */
const sidebarFocusOn = (
  sidebar: SidebarItem[],
  target: string,
  closeOther: boolean = false
): SidebarItem[] =>
  sidebar.map((item) =>
    item.items && item.items.length > 0
      ? {
          ...item,
          collapsed: closeOther ? true : item.collapsed,
          items: sidebarFocusOn(item.items, target, closeOther),
        }
      : {
          ...item,
          collapsed: item.text === target ? item.collapsed : true,
        }
  );

export const routes = generateSidebarConfig(config);
