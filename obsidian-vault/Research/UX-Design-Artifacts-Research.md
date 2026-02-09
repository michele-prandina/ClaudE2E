---
description: "Comprehensive research on all UX and product design artifacts needed before implementation to prevent surprises"
tags:
  - type/research
  - domain/ux
  - domain/product-design
  - phase/product-spec
---

# Complete UX & Product Design Artifacts: Discovery to Implementation

## Executive Summary

Between research/discovery and the start of implementation, product teams must produce artifacts across twelve interconnected categories: service design, user research, user journeys, information architecture, interaction design, wireframes/prototypes, visual design, content design, specifications, validation plans, edge case documentation, and cross-cutting concerns. The single biggest cause of implementation surprises is not missing artifacts but insufficient depth within artifacts -- teams create a user flow but omit error states, or build a design system but skip loading skeletons. This report catalogs every artifact, specifies the level of detail required to eliminate developer surprises, identifies the most effective format for each (with reasoning), and maps the dependency chain between artifacts. The recommendations synthesize established frameworks from Nielsen Norman Group, IDEO, the UK Design Council's Double Diamond, Lean UX, and contemporary design systems thinking from Figma, Material Design, and the GOV.UK Design System. Where trade-offs exist between Lean UX (minimal artifacts, fast iteration) and traditional UX (comprehensive documentation), this report sides with "just enough documentation" -- the minimum artifact set that closes every ambiguity gap a developer would encounter.

---

## Table of Contents

1. [Service Design Artifacts](#1-service-design-artifacts)
2. [User Research Artifacts](#2-user-research-artifacts)
3. [User Journey Artifacts](#3-user-journey-artifacts)
4. [Information Architecture](#4-information-architecture)
5. [Interaction Design Artifacts](#5-interaction-design-artifacts)
6. [Wireframes and Prototypes](#6-wireframes-and-prototypes)
7. [Visual Design Artifacts](#7-visual-design-artifacts)
8. [Content Design Artifacts](#8-content-design-artifacts)
9. [Specification Artifacts](#9-specification-artifacts)
10. [Validation Artifacts](#10-validation-artifacts)
11. [Edge Case Documentation](#11-edge-case-documentation)
12. [Cross-Cutting Concerns](#12-cross-cutting-concerns)
13. [Master Artifact Dependency Map](#13-master-artifact-dependency-map)
14. [Sources](#14-sources)

---

## 1. Service Design Artifacts

**Confidence: High**

### 1.1 Service Blueprint

**What it is and why it exists.** A service blueprint is a diagram that visualizes the relationships between different service components -- people, physical or digital touchpoints, and processes -- that are directly tied to a specific customer journey [1]. Unlike a journey map (which shows only the customer perspective), a service blueprint exposes the frontstage actions, backstage actions, support processes, and physical evidence that must exist for the service to function. It exists because developers need to understand not just what the user sees, but what systems, APIs, third-party services, and human processes support each interaction.

**Best format and why.** A swimlane diagram with five horizontal lanes (physical evidence, customer actions, frontstage interactions, backstage interactions, support processes) separated by three lines of visibility (line of interaction, line of visibility, line of internal interaction). Miro or FigJam are the best tools because blueprints need to be collaboratively editable and large-format. The NNGroup five-lane format is preferred over simpler three-lane versions because the support processes lane is where most implementation surprises hide -- it surfaces the databases, microservices, and third-party integrations that developers need to build [1][2].

**Level of detail needed.** Every customer action must map to at least one frontstage interaction and one backstage process. Each backstage process must name the specific system or service involved (e.g., "Stripe Payments API" not "payment system"). Include time annotations where processes are asynchronous. Mark failure points with a "fail" symbol and reference the corresponding error state documentation.

**Common mistakes.** (1) Making the blueprint too abstract. (2) Omitting the support processes lane entirely. (3) Not linking blueprint steps to specific user flows or screens. (4) Creating a single blueprint for the entire product instead of one per key journey.

**Dependencies.** Requires completed user journey maps as input. Feeds into technical architecture decisions and API design.

### 1.2 Ecosystem Map

**What it is and why it exists.** An ecosystem map visualizes all the actors (users, organizations, systems, devices) and the relationships/data flows between them in the broader system within which your product operates [3]. It prevents the "we didn't realize we needed to integrate with X" surprise.

**Best format and why.** A network diagram with nodes (actors) and edges (relationships/data flows), annotated with the type of exchange (data, money, information, physical goods). Miro or Kumu.io are best for interactive exploration.

**Level of detail needed.** Every external system your product will interact with must appear. Every data flow must be labeled with what data moves, in what format, and in which direction.

**Common mistakes.** (1) Only mapping human stakeholders and forgetting technical systems. (2) Not distinguishing between current-state and future-state ecosystems. (3) Omitting regulatory or compliance actors.

### 1.3 Stakeholder Map

**What it is and why it exists.** A stakeholder map identifies all people and groups who have an interest in or influence over the product, plotted on axes of influence vs. interest [4].

**Best format and why.** A 2x2 matrix (influence vs. interest) with stakeholders plotted as nodes, supplemented by a stakeholder register spreadsheet.

**Level of detail needed.** Name every stakeholder role. For each, note: their primary concern, how they'll interact with the product, what decision-making power they hold.

**Common mistakes.** (1) Only mapping direct users and ignoring indirect stakeholders. (2) Not revisiting the map as the project evolves.

---

## 2. User Research Artifacts

**Confidence: High**

### 2.1 Personas

**What it is and why it exists.** A persona is an archetypal representation of a user segment, based on research data, that communicates user goals, behaviors, pain points, and context to the product team [5]. Personas exist to prevent self-referential design by grounding every design decision in evidence about real users.

**Best format and why.** The "goal-directed persona" format (from Alan Cooper's About Face) is the most effective because it centers on what users are trying to accomplish rather than demographic trivia [5][6]. A goal-directed persona includes: (1) a name and photo, (2) a behavioral archetype description, (3) 3-5 goals ranked by priority, (4) key behaviors and habits, (5) frustrations/pain points, (6) technology comfort level, (7) a quote that captures their mindset. This format is superior to demographic-heavy personas because demographics rarely predict behavior. It is also preferred over purely narrative personas because the structured format makes it scannable for developers.

**Level of detail needed.** Each persona must include at least one scenario. Include "anti-goals" -- things this persona explicitly does NOT want. Limit to 3-5 personas; more than that and the team cannot internalize them.

**Common mistakes.** (1) Creating personas from assumptions instead of research data. (2) Including too many personas. (3) Making personas too detailed on demographics and too thin on goals. (4) Not updating personas as new research emerges.

### 2.2 Empathy Maps

**What it is and why it exists.** An empathy map is a collaborative visualization that articulates what a user segment says, thinks, does, and feels [7]. It is NOT a replacement for personas but a complementary tool.

**Best format and why.** The NNGroup updated format with four quadrants (Says, Thinks, Does, Feels) plus Pains and Gains sections [7]. This six-section format is preferred over the original four-quadrant version because the explicit Pains/Gains sections directly feed into value proposition design.

**Level of detail needed.** Each quadrant should have 5-8 specific, research-backed observations (not assumptions).

### 2.3 Jobs-to-be-Done (JTBD) Framework

**What it is and why it exists.** JTBD describes the progress a person is trying to make in a particular circumstance: "When [situation], I want to [motivation], so I can [expected outcome]" [8][9]. It exists because personas describe WHO users are, while JTBD describes WHAT they're trying to accomplish.

**Best format and why.** The "Job Story" format (When... I want to... So I can...) is preferred over traditional user stories for design artifacts because it focuses purely on the situational trigger, motivation, and desired outcome [9]. Use the Outcome-Driven Innovation (ODI) format from Tony Ulwick when you need to prioritize with quantitative "opportunity scores" [10].

**Level of detail needed.** For each primary persona, identify 5-15 jobs. For each job, document: (1) the job statement, (2) the triggering circumstance, (3) the desired outcome, (4) current workarounds, (5) the emotional and social dimensions.

**Common mistakes.** (1) Writing jobs that are actually features in disguise. (2) Ignoring the circumstance/trigger. (3) Only documenting functional jobs and missing emotional/social jobs.

### 2.4 User Research Repository / Insights Database

**What it is and why it exists.** A structured repository that stores all research observations, tagged by theme, persona, journey stage, and feature area [11]. It prevents research from being "done and forgotten."

**Best format and why.** Dovetail, EnjoyHQ, or a well-structured Notion/Obsidian database with: (1) atomic observations, (2) tags for persona, journey stage, theme, and severity, (3) links to source data, (4) a synthesis layer grouping observations into themes.

**Level of detail needed.** Every design decision that might be questioned during implementation should trace back to a specific research insight. Include verbatim quotes, not just paraphrases.

---

## 3. User Journey Artifacts

**Confidence: High**

### 3.1 User Journey Map

**What it is and why it exists.** A user journey map visualizes the process a specific persona goes through to accomplish a specific goal with your product, including their actions, thoughts, emotions, pain points, and opportunities at each stage [12].

**Best format and why.** A horizontal timeline divided into phases, with swimlanes for: (1) stages/phases, (2) user actions, (3) touchpoints, (4) thoughts/questions, (5) emotions (as a curve), (6) pain points, (7) opportunities. Digital tools (Miro, FigJam, UXPressia, Smaply) are preferred because journey maps are living documents [12].

**Difference from other map types.** A "user journey map" is product-specific and persona-specific. An "experience map" is persona-agnostic and maps a general human experience. A "customer journey map" is the broadest term used in marketing [12][13]. For implementation, you need user journey maps because they directly inform what screens and states developers must build.

**Level of detail needed.** Each phase must list every touchpoint and channel. Every action must specify what the user sees, does, and decides. Map the journey for BOTH the happy path AND the primary alternative/error paths.

**Common mistakes.** (1) Mapping only the happy path. (2) Making the map too high-level. (3) Not grounding the journey in research data. (4) Creating one journey map for all personas instead of one per primary persona.

### 3.2 Experience Map

**What it is and why it exists.** An experience map visualizes the entire end-to-end experience of a general activity (not tied to a specific product) [12]. It is useful in early discovery when exploring the problem space before committing to a product direction.

**Best format and why.** Same swimlane format as journey maps but without product-specific touchpoints. The key addition is a "current solutions/workarounds" lane.

---

## 4. Information Architecture

**Confidence: High**

### 4.1 Site Map / App Map

**What it is and why it exists.** A site map is a hierarchical diagram showing the structure of all pages/screens in a product and their relationships [14]. Without it, developers discover missing screens mid-implementation.

**Best format and why.** A hierarchical tree diagram using Figma, FigJam, Miro, or OmniGraffle. Each node represents a unique screen/page labeled with a descriptive name and unique ID (e.g., "S-01: Dashboard"). Include annotations for: (1) navigation links, (2) conditional access, (3) role-based variations [14].

**Level of detail needed.** EVERY screen in the product must appear, including screens that are often forgotten: settings pages, error pages (404, 500, 403), email verification, password reset, onboarding flows, empty states, admin views, and legal pages.

**Common mistakes.** (1) Omitting utility pages (404, 500, maintenance). (2) Not showing screens that differ by user role. (3) Confusing site maps with navigation menus.

### 4.2 Content Model

**What it is and why it exists.** A content model defines the types of content in the product, their attributes, and relationships [15]. For example: "Article" has title (string, required, max 120 chars), body (rich text, required), author (reference to User), tags (array), published_date (datetime), status (draft/published/archived).

**Best format and why.** A structured table or entity-relationship diagram showing: (1) content type name, (2) each field with its data type, constraints, (3) relationships between content types. Must be structured data, not prose -- developers need to translate this directly into database schemas.

**Level of detail needed.** Every field that appears in ANY design must be defined with its data type, constraints, and validation rules. Include: default values, what happens when a field is empty, maximum lengths, allowed values for enumerations.

### 4.3 Taxonomy and Navigation Model

**What it is and why it exists.** A taxonomy defines the categorization system used to organize and find content [16]. The navigation model defines primary, secondary, and utility navigation structures. Poor categorization and navigation are extremely expensive to change after implementation.

**Best format and why.** For taxonomy: a hierarchical tree with definitions for each category and rules for categorization. For navigation: annotated wireframes at all levels, including mobile adaptations. Card sorting results should be documented alongside the taxonomy.

**Level of detail needed.** The taxonomy must define every category at every level. The navigation model must specify behavior at all breakpoints and for all user roles. Include search behavior: what's searchable, how results are ranked, what filters are available.

---

## 5. Interaction Design Artifacts

**Confidence: High**

### 5.1 User Flows

**What it is and why it exists.** A user flow is a diagram showing the complete path a specific user takes through the product to accomplish a specific task, including all decision points, branches, and outcomes [17]. It exists to ensure every possible path through the product is designed and built.

**Best format and why.** Flowchart notation using standard shapes: rectangles for screens, diamonds for decision points, rounded rectangles for start/end points. Figma, FigJam, Whimsical, or Lucidchart are preferred. Use color coding: green for success, red for errors, yellow for edge cases.

**Level of detail needed.** THIS IS THE MOST CRITICAL ARTIFACT FOR PREVENTING IMPLEMENTATION SURPRISES. Every decision point must show ALL possible outcomes. For each screen annotate: (1) entry conditions, (2) available actions, (3) system responses to each action, (4) exit paths.

**For every user action, document these states:**
- **Success state**: What the user sees when the action succeeds
- **Error state**: What the user sees when the action fails (with specific error messages)
- **Loading state**: What the user sees while waiting
- **Empty state**: What the user sees when there's no data
- **Partial state**: What the user sees when data is incomplete
- **Permission denied state**: What the user sees when they lack access
- **Offline state**: What the user sees without connectivity (if applicable)

**Common mistakes.** (1) Only diagramming the happy path. (2) Not showing what happens when the user navigates backward or abandons the flow. (3) Not specifying what triggers system actions. (4) Not accounting for user roles with different permissions. (5) Not specifying timeout behaviors.

### 5.2 Task Flows

**What it is and why it exists.** A task flow is a single-path diagram showing one specific task from start to finish, without branching [17]. It represents the ideal/expected path. Useful for developers implementing the "happy path" first.

**Best format and why.** A linear sequence of screen thumbnails or descriptions connected by arrows. This is the artifact developers use when they say "just tell me the happy path first."

### 5.3 Wireflows

**What it is and why it exists.** A wireflow combines wireframes with flow diagrams, showing actual screen layouts at each step of a flow rather than abstract boxes [18]. Wireflows give developers both visual context and sequential context.

**Best format and why.** Reduced-fidelity wireframes (mid-fi) connected by arrows showing the flow, with annotations for interactions and state changes. Figma is the best tool.

---

## 6. Wireframes and Prototypes

**Confidence: High**

### 6.1 Low-Fidelity Wireframes (Sketches)

**What it is and why it exists.** Low-fi wireframes are rough layouts that show screen structure without visual design detail [19]. They exist for rapid exploration -- it's cheap to throw away a sketch.

**Best format and why.** Paper sketches or Balsamiq, Whimsical, or Figma with a wireframe kit. The deliberate lack of polish communicates "this is not final."

**Level of detail needed.** Show: content hierarchy, primary interaction elements, and layout structure. Do NOT include: colors, typography, images, precise spacing, or real content.

### 6.2 Mid-Fidelity Wireframes

**What it is and why it exists.** Mid-fi wireframes add structural detail: real content hierarchy, approximate sizing, interaction element states, and basic responsive behavior [19]. The primary artifact for alignment between design, product, and engineering.

**Best format and why.** Figma is the dominant tool because it supports components, auto-layout, and prototyping in one tool. Use a grayscale palette with a single accent color. This is the "Goldilocks fidelity."

**Level of detail needed.** EVERY screen in the site map must have a mid-fi wireframe. EVERY state identified in the user flows must have its own wireframe variation. Include: real content hierarchy (not lorem ipsum), form field types and validation rules, button states, responsive behavior notes.

### 6.3 High-Fidelity Mockups

**What it is and why it exists.** High-fi mockups are pixel-perfect representations of the final visual design [19]. They communicate exact visual design intent to developers.

**Best format and why.** Figma (industry standard as of 2024-2025) because of its design token support, component variants, auto-layout, dev mode, and plugin ecosystem [20]. Build using the design system component library.

**Level of detail needed.** Must use exact values from the design system. You do NOT need high-fi mockups for every screen -- prioritize primary screens, unique visual treatments, and one example of each common pattern.

### 6.4 Interactive Prototypes

**What it is and why it exists.** Interactive prototypes connect screens with interactions to simulate the actual product experience [19]. They exist for usability testing and communicating complex interactions.

**Best format and why.** Figma prototyping for standard click-through prototypes. For complex interactions (drag and drop, complex animations), use Framer, ProtoPie, or Principle. Use the simplest tool that can express the interaction.

---

## 7. Visual Design Artifacts

**Confidence: High**

### 7.1 Design Tokens

**What it is and why it exists.** Design tokens are the atomic values of a design system: colors, typography, spacing, border radii, shadows, motion durations, and breakpoints, stored in a platform-agnostic format [21]. They are the single most important bridge between design and development.

**Best format and why.** The W3C Design Token Community Group format (JSON) is the emerging standard [21]. Store tokens in a JSON file in the code repository AND in Figma (using Figma Variables or Tokens Studio). Tokens should be organized in three tiers: (1) primitive/global tokens (raw values), (2) semantic/alias tokens (purpose-based), (3) component-specific tokens (scoped).

**Level of detail needed.** At minimum, define tokens for: color palette (with semantic names), typography scale, spacing scale, border radii, shadows, breakpoints, and motion. EVERY value in EVERY mockup must trace back to a token.

**Common mistakes.** (1) Defining color tokens without semantic naming. (2) Not defining all three tiers. (3) Not syncing tokens between Figma and code. (4) Not including motion and animation tokens.

### 7.2 Component Library / Design System

**What it is and why it exists.** A component library is a collection of reusable UI components built with consistent design tokens and documented with usage guidelines [22]. It ensures visual and behavioral consistency and serves as the authoritative specification.

**Best format and why.** Figma component library paired with a coded component library that mirrors it 1:1. Storybook is the industry-standard tool for documenting coded components [23].

**Minimum Viable Design System (before implementation can begin):**
1. **Design tokens** (color, typography, spacing, shadows, motion)
2. **Primitive components**: Button (all variants/states), Input (all types/states), Link, Icon set, Avatar, Badge, Tag/Chip
3. **Layout components**: Container, Grid/Flex layout, Card, Divider, Spacer
4. **Navigation components**: Header/Navbar, Sidebar, Breadcrumbs, Tabs, Pagination
5. **Feedback components**: Alert/Banner, Toast/Snackbar, Modal/Dialog, Tooltip, Progress bar, Skeleton/Loading, Empty state template, Error state template
6. **Data display components**: Table (with sorting, filtering, pagination), List, Data point/Stat
7. **Form patterns**: Form layout, Field group, Validation messages, Form actions

For each component, document: (1) all visual variants, (2) all interactive states (default, hover, focus, active, disabled, loading, error), (3) all size variants, (4) responsive behavior, (5) accessibility requirements, (6) do's and don'ts.

### 7.3 Iconography and Illustration System

**What it is and why it exists.** A defined set of icons and illustrations with consistent style, sizing, and usage guidelines. Prevents mixing icon styles from different sources.

**Best format and why.** SVG format for icons, organized as a Figma component library and exported as an icon font or SVG sprite for development. Use a single icon set (Lucide, Phosphor, Heroicons, or custom).

---

## 8. Content Design Artifacts

**Confidence: High**

### 8.1 Content Matrix / Content Inventory

**What it is and why it exists.** A content matrix maps every piece of content in the product: what it says, where it appears, who owns it, what triggers it [24]. It prevents the "oh, we forgot about that email" and "nobody wrote the error messages" problems.

**Best format and why.** A spreadsheet (Google Sheets or Airtable) with columns: (1) Content ID, (2) Content type, (3) Screen/location, (4) Trigger condition, (5) Content text, (6) Character limit, (7) Variants (by locale, user role), (8) Owner, (9) Status. A spreadsheet is preferred because it's sortable, filterable, and exportable as JSON/CSV for developers.

**Level of detail needed.** EVERY piece of text a user sees must be in this matrix, including: all error messages, empty state messages, confirmation dialogs, success messages, notification text (push, email, in-app), tooltip text, onboarding text, legal text, form labels and placeholder text, and accessibility text (alt text, ARIA labels).

**Common mistakes.** (1) Not creating the matrix, leading to developers writing their own copy. (2) Not including emails and notifications (most commonly forgotten). (3) Not specifying character limits. (4) Not specifying dynamic parts of content.

### 8.2 Voice and Tone Guidelines

**What it is and why it exists.** A document defining the product's voice (consistent personality) and tone (how the voice adapts to different situations) [25].

**Best format and why.** A reference document with: (1) voice principles (3-5 adjectives with do/don't examples), (2) a tone spectrum showing how tone shifts across contexts, (3) a word list (preferred terms and terms to avoid), (4) real examples. The Mailchimp Content Style Guide format is the gold standard [25].

### 8.3 Email and Notification Templates

**What it is and why it exists.** Complete specifications for every automated communication the product sends [24]. These are the most commonly "forgotten" content artifacts.

**Best format and why.** For each communication: (1) trigger condition, (2) timing, (3) recipient definition, (4) subject line, (5) body content with dynamic fields marked, (6) CTA with destination URL, (7) visual design template, (8) fallback behavior.

**Level of detail needed.** EVERY automated communication must be defined before implementation: welcome email, email verification, password reset, account locked, payment confirmation, payment failure, subscription renewal reminder, trial expiration, team invitation, mention notification, comment notification, digest email, re-engagement email, account deletion confirmation.

---

## 9. Specification Artifacts

**Confidence: High**

### 9.1 Design Specifications (Redlines)

**What it is and why it exists.** Design specifications document the exact measurements, spacing, colors, typography, and component properties for every element in every screen [26]. In the Figma era, much is handled by Dev Mode, but specs are still needed for behavior that visual inspection cannot convey.

**Best format and why.** Figma Dev Mode is the primary handoff tool because it auto-generates CSS values, spacing measurements, and asset exports [20]. Supplement with annotation layers in Figma for: conditional logic, responsive behavior changes, animation triggers, and dynamic content rules. Avoid separate PDF redlines -- they become outdated immediately.

**Level of detail needed.** All measurements must use design tokens (not raw pixel values). Responsive behavior must be annotated at each breakpoint. Dynamic behavior must be described (e.g., "truncate after 2 lines with ellipsis"). Z-index and layering must be specified.

### 9.2 Interaction Specifications

**What it is and why it exists.** Interaction specs document how every interactive element behaves: what triggers the interaction, what happens during it, and what state results [26]. Covers hover effects, focus states, click/tap behavior, gestures, keyboard shortcuts, and form validation logic.

**Best format and why.** An interaction spec table is the most developer-friendly format:

| Element | Trigger | Action | Animation | End State |
|---------|---------|--------|-----------|----------|
| Submit button | Click | Validate form, show spinner, submit | Button: 200ms scale to 0.95, spinner: fade in 150ms | Success: redirect. Error: show inline errors |

**Level of detail needed.** Every interactive element must have defined behavior for: (1) all pointer states, (2) keyboard interaction, (3) touch interaction, (4) loading behavior, (5) error behavior.

**Common mistakes.** (1) Not specifying keyboard interactions. (2) Not specifying what "disabled" means for each element. (3) Not specifying form validation timing (on change? On blur? On submit?). (4) Not specifying debounce/throttle behavior.

### 9.3 Animation and Motion Specifications

**What it is and why it exists.** Animation specs define every motion in the product [27]. Unspecified animation leads to either no animation or inconsistent animation.

**Best format and why.** A motion design language document defining: (1) motion principles, (2) standard duration values (quick: 100-200ms, normal: 200-350ms, slow: 350-500ms), (3) standard easing curves (with CSS cubic-bezier values), (4) animation patterns. Reference motion tokens from the design token system.

**Level of detail needed.** For each animation: (1) trigger, (2) properties animated, (3) duration in ms, (4) easing curve with CSS value, (5) delay if staggered, (6) reduced-motion alternative.

### 9.4 Responsive Design Specifications

**What it is and why it exists.** Responsive specs define how every screen and component adapts across viewport sizes [28]. If you only design at 1440px, developers must guess what happens at 375px.

**Best format and why.** Design each key screen at defined breakpoints (minimum: mobile 375px, tablet 768px, desktop 1280px, large desktop 1440px+). For each breakpoint annotate: (1) what changes, (2) what stays the same, (3) touch-specific interactions replacing hover on mobile.

**Level of detail needed.** Every screen must be designed at minimum two breakpoints (mobile and desktop). Navigation must be fully specified at all breakpoints. Tables must specify their mobile treatment.

---

## 10. Validation Artifacts

**Confidence: High**

### 10.1 Usability Test Plan

**What it is and why it exists.** A structured document defining what will be tested, with whom, how, and what success looks like BEFORE any test sessions occur [29].

**Best format and why.** A document containing: (1) research questions, (2) methodology, (3) participant criteria, (4) task scenarios, (5) success metrics, (6) the artifact being tested, (7) analysis plan. The plan should be created BEFORE prototyping.

**Level of detail needed.** Each task scenario must be a realistic goal-oriented scenario, not step-by-step instructions. Include at least one scenario per primary user flow and one that tests error recovery.

### 10.2 A/B Test Hypotheses

**What it is and why it exists.** Structured hypotheses for post-launch experiments, defined before implementation so analytics instrumentation can be built in [30]. Format: "If we [change], then [metric] will [improve/decrease] by [amount] because [reasoning]."

**Best format and why.** A structured table with: Hypothesis ID, change being tested, metric measured, expected direction/magnitude, minimum sample size, test duration, implementation requirements, decision rule.

### 10.3 Analytics Instrumentation Plan

**What it is and why it exists.** A specification of every analytics event, property, and user attribute that must be tracked [31]. Analytics added after launch are always incomplete.

**Best format and why.** A spreadsheet (or Avo, Amplitude Data, Segment Protocols) with: (1) Event name (consistent naming convention), (2) Trigger condition, (3) Event properties, (4) User properties to update, (5) Which platforms receive the event, (6) Which funnels/tests it supports.

**Level of detail needed.** Every user action in every user flow must have a corresponding analytics event. Every funnel must have events at each step. Error events must be tracked.

---

## 11. Edge Case Documentation

**Confidence: High**

### 11.1 Comprehensive State Inventory

**What it is and why it exists.** A systematic catalog of every possible state that every screen and component can be in [32]. This is the artifact most often missing from design handoffs and the primary cause of "implementation surprises."

**The Complete State Taxonomy:**

**Content States:**
- **Ideal state**: Typical, moderate amount of real data
- **Empty state**: No data yet (first-time user, no search results, empty list)
- **Single item state**: Only one item (impacts layout)
- **Maximum content state**: Maximum possible data (long names, many items, truncation)
- **Minimal content state**: Minimum possible data (only required fields)
- **Stale data state**: Data that may be outdated

**Loading States:**
- **Initial loading**: First time loading, no cached data (skeleton screens)
- **Refresh loading**: Reloading data user has seen before
- **Partial loading**: Some content loaded, some still loading
- **Infinite scroll loading**: Loading more items in a paginated list
- **Action loading**: Waiting for user action to complete

**Error States:**
- **Network error**: No internet connection
- **Server error**: 5xx responses
- **Timeout error**: Request took too long
- **Validation error**: Input doesn't meet requirements
- **Authentication error**: Session expired, token invalid
- **Authorization error**: User lacks permission
- **Not found error**: Resource doesn't exist (404)
- **Rate limit error**: Too many requests
- **Conflict error**: Resource modified by another user
- **Payment error**: Payment method declined
- **Quota error**: User exceeded a plan limit
- **Dependency error**: Third-party service unavailable

**Permission States:**
- **Unauthenticated**: User not logged in
- **Authenticated but unauthorized**: Logged in but lacks access
- **Role-based variations**: What each role can see/do (admin, member, viewer, guest)
- **Feature-gated**: Behind a paywall or feature flag
- **Account-level restrictions**: Free vs. paid tier differences

**Connectivity States:**
- **Online**: Normal connectivity
- **Offline**: No connection
- **Slow connection**: Degraded connectivity
- **Reconnecting**: Connection lost and being restored

**Lifecycle States:**
- **Onboarding**: First-time user experience
- **Regular use**: Standard returning user experience
- **Power user**: Keyboard shortcuts, advanced features
- **Churning**: User hasn't returned in a while
- **Account degraded**: Trial expired, payment failed
- **Account suspended**: Access restricted
- **Account deleted/deactivated**: What happens to data

**Best format and why.** A matrix (spreadsheet) with screens/components as rows and states as columns. Empty cells are missing designs. Supplement with a Figma page for state variations.

**Level of detail needed.** EVERY screen must be evaluated against EVERY state category. For each applicable state, there must be either a wireframe/mockup or a written specification.

**Common mistakes.** (1) Only designing the "ideal state" and one generic error state. (2) Not defining empty states (the number-one most forgotten state). (3) Not specifying loading behavior. (4) Not designing for permission variations. (5) Treating "offline" as binary.

---

## 12. Cross-Cutting Concerns

**Confidence: High**

### 12.1 Accessibility Specifications (WCAG)

**What it is and why it exists.** A document specifying how the product will comply with WCAG, typically targeting WCAG 2.2 Level AA [33]. Accessibility is both a legal requirement and dramatically cheaper to implement from the start than to retrofit.

**Best format and why.** An accessibility spec should include: (1) target WCAG level, (2) keyboard interaction patterns for every component, (3) ARIA attributes for each component, (4) focus management rules, (5) color contrast ratios, (6) alternative text policy, (7) screen reader announcement rules, (8) reduced motion policy. The spec should be integrated into the component library documentation.

**Level of detail needed.** Every interactive component must have defined keyboard interaction. Every image must have an alt text rule. Every dynamic content change must specify screen reader behavior. Every color combination must pass contrast checking.

**Common mistakes.** (1) Treating accessibility as a checkbox exercise. (2) Not specifying keyboard interactions. (3) Not specifying focus management for dynamic content. (4) Only testing with automated tools.

### 12.2 Internationalization (i18n) Requirements

**What it is and why it exists.** A specification for how the product will support multiple languages, locales, and cultural conventions [34]. Even for a single-language launch, i18n architecture decisions must be made before implementation because retrofitting is extremely expensive.

**Best format and why.** A requirements document covering: (1) supported languages, (2) text direction (LTR, RTL), (3) string externalization strategy, (4) pluralization rules, (5) date/time/number/currency formatting per locale, (6) content length accommodation (German text is ~30%% longer than English), (7) cultural considerations, (8) translation workflow.

**Level of detail needed.** At minimum, even for English-only: (1) define string externalization approach, (2) design layouts that accommodate 30-50%% text expansion, (3) define locale-aware formatting, (4) identify hard-coded cultural assumptions.

**Common mistakes.** (1) Hard-coding strings. (2) Designing layouts that break with longer text. (3) Hard-coding date formats. (4) Not considering RTL layout. (5) Concatenating strings instead of using parameterized templates.

### 12.3 Performance Budgets

**What it is and why it exists.** Quantitative limits on performance metrics defined before implementation so architectural decisions support these targets [35].

**Best format and why.** A performance budget table:

| Metric | Budget | Measurement Tool |
|--------|--------|------------------|
| First Contentful Paint (FCP) | < 1.8s | Lighthouse |
| Largest Contentful Paint (LCP) | < 2.5s | Lighthouse |
| Cumulative Layout Shift (CLS) | < 0.1 | Lighthouse |
| Interaction to Next Paint (INP) | < 200ms | Lighthouse |
| Total page weight (compressed) | < 500KB | DevTools |
| JavaScript bundle size | < 200KB | Webpack Bundle Analyzer |
| Time to Interactive (TTI) | < 3.5s | Lighthouse |
| API response time (p95) | < 500ms | APM |

**Common mistakes.** (1) Not defining performance budgets at all. (2) Defining budgets but not enforcing them in CI/CD. (3) Only defining page load budgets and not interaction/API budgets.

### 12.4 SEO Requirements

**What it is and why it exists.** A specification for SEO requirements that affect design and development decisions [36]. SEO requirements influence URL structure, page titles, heading hierarchy, metadata, rendering strategy (SSR vs. CSR), and content structure.

**Best format and why.** A requirements document covering: (1) URL structure and routing patterns, (2) page title and meta description templates per page type, (3) heading hierarchy rules, (4) structured data/schema.org markup, (5) canonical URL strategy, (6) sitemap generation, (7) robots.txt, (8) rendering strategy recommendation (SSR, SSG, ISR), (9) image alt text conventions, (10) internal linking requirements.

**Level of detail needed.** Enough for developers to implement the correct rendering strategy, URL structure, and metadata from the initial build. Retrofitting SSR onto a CSR app is one of the most expensive rework items.

---

## 13. Master Artifact Dependency Map

The following shows the creation order and dependencies between all artifacts:

```
PHASE 1: DISCOVERY
  Stakeholder Map
  Ecosystem Map
  User Research Repository (initialized)
  User Interviews/Observations
  Experience Maps (general activity, not product-specific)
  Competitive Analysis

PHASE 2: DEFINITION
  Personas (from research data)
  Empathy Maps (from research data)
  Jobs-to-be-Done (from research data)
  User Journey Maps (per persona, product-specific)
    Requires: Personas
  Service Blueprints
    Requires: Journey Maps
  Voice and Tone Guidelines

PHASE 3: STRUCTURE
  Information Architecture
    Site Map / App Map
      Requires: Journey Maps, JTBD
    Content Model
      Requires: Site Map, Journey Maps
    Taxonomy and Navigation Model
      Requires: Card Sorting research, Content Model
  User Flows (all paths, all states)
    Requires: Personas, Journey Maps, Site Map
  Task Flows (happy paths)
    Requires: User Flows
  Edge Case State Inventory
    Requires: User Flows, Site Map

PHASE 4: DESIGN
  Design Tokens
    Requires: Brand Guidelines, Cross-cutting specs
  Component Library (minimum viable)
    Requires: Design Tokens
  Low-fi Wireframes (exploration)
    Requires: User Flows, Site Map
  Mid-fi Wireframes (all screens, all states)
    Requires: Low-fi wireframes, Edge Case Inventory
  Content Matrix (all copy)
    Requires: Mid-fi Wireframes, Voice/Tone Guidelines
  Wireflows
    Requires: Mid-fi Wireframes, User Flows
  Interactive Prototypes (key flows)
    Requires: Mid-fi Wireframes

PHASE 5: SPECIFICATION
  High-fi Mockups (key screens)
    Requires: Component Library, Mid-fi Wireframes
  Interaction Specifications
    Requires: User Flows, Component Library
  Animation and Motion Specifications
    Requires: Interaction Specs, Design Tokens
  Responsive Design Specifications
    Requires: High-fi Mockups at all breakpoints
  Email and Notification Templates
    Requires: Content Matrix, Visual Design
  Design Specifications (redlines, via Figma Dev Mode)
    Requires: High-fi Mockups, Design Tokens
  Accessibility Specifications
    Requires: Component Library, Interaction Specs

PHASE 6: VALIDATION PLANNING
  Usability Test Plan
    Requires: Prototypes, User Flows
  A/B Test Hypotheses
    Requires: Design decisions, User Flows
  Analytics Instrumentation Plan
    Requires: User Flows, A/B Hypotheses

CROSS-CUTTING (define early, refine throughout):
  Accessibility Specs (WCAG 2.2 AA)
  Internationalization Requirements
  Performance Budgets
  SEO Requirements
```

### Lean UX vs. Traditional: Which Artifacts to Cut

For teams practicing Lean UX or operating under tight constraints, the absolute minimum artifact set that prevents implementation surprises (in priority order) is:

1. **User Flows with ALL states documented** -- This single artifact prevents more surprises than any other
2. **Design Tokens** -- Without these, design-code consistency is impossible
3. **Component Library (minimum viable)** -- Without this, every screen is a one-off implementation
4. **Content Matrix** -- Without this, developers write copy and emails are forgotten
5. **Edge Case State Inventory** -- The matrix of screens x states with documented behavior
6. **Mid-fi Wireframes for all screens and all states** -- The visual source of truth
7. **Interaction Specifications** -- What every element does on every trigger

Everything else improves quality and team alignment but can be abbreviated or created iteratively. The seven artifacts above are NON-NEGOTIABLE for zero-surprise implementation.

---

## 14. Sources

[1] Gibbons, S. "Service Blueprints: Definition." Nielsen Norman Group. https://www.nngroup.com/articles/service-blueprints-definition/ -- Foundational reference for service blueprint methodology, five-lane format, and key components.

[2] Shostack, G.L. "Designing Services That Deliver." Harvard Business Review, 1984. -- Original service blueprint methodology paper.

[3] Polaine, A., Lovlie, L., Reason, B. "Service Design: From Insight to Implementation." Rosenfeld Media, 2013. -- Comprehensive service design reference covering ecosystem maps and stakeholder maps.

[4] Curedale, R. "Design Thinking: Process and Methods." Design Community College, 2016. -- Covers stakeholder mapping methods including power/interest grids.

[5] Cooper, A. "About Face: The Essentials of Interaction Design." Wiley, 4th edition, 2014. -- Original goal-directed persona methodology.

[6] Goodwin, K. "Designing for the Digital Age." Wiley, 2009. -- Expanded persona methodology with practical implementation guidance.

[7] Gibbons, S. "Empathy Mapping: The First Step in Design Thinking." Nielsen Norman Group. https://www.nngroup.com/articles/empathy-mapping/ -- Updated empathy map format with pains and gains sections.

[8] Christensen, C.M. et al. "Competing Against Luck: The Story of Innovation and Customer Choice." Harper Business, 2016. -- Foundational JTBD framework.

[9] Klement, A. "When Coffee and Kale Compete." Self-published, 2018. -- Job Story format and situational JTBD methodology.

[10] Ulwick, A. "What Customers Want." McGraw-Hill, 2005. -- Outcome-Driven Innovation framework for quantifying jobs-to-be-done.

[11] Portigal, S. "Dovetail and EnjoyHQ: User Research Repository Platforms." Various industry reviews, 2023-2024. -- Research repository tools and atomic research methodology.

[12] Gibbons, S. "Journey Mapping 101." Nielsen Norman Group. https://www.nngroup.com/articles/journey-mapping-101/ -- Definitive guide to journey map types, components, and best practices.

[13] Kalbach, J. "Mapping Experiences." O'Reilly Media, 2nd edition, 2020. -- Comprehensive reference distinguishing experience maps, journey maps, service blueprints.

[14] Rosenfeld, L., Morville, P., Arango, J. "Information Architecture: For the Web and Beyond." O'Reilly Media, 4th edition, 2015. -- Industry-standard reference for site maps, taxonomy, content models.

[15] Barker, D. "Web Content Management." O'Reilly Media, 2016. -- Content modeling methodology and structured content design.

[16] Spencer, D. "Card Sorting: Designing Usable Categories." Rosenfeld Media, 2009. -- Taxonomy design and card sorting methodology.

[17] "User Flows vs. Task Flows." Nielsen Norman Group, various articles. -- Distinction between user flows (branching) and task flows (linear).

[18] Page, C. "Wireflows: A UX Deliverable for Workflows and Apps." Nielsen Norman Group. https://www.nngroup.com/articles/wireflows/ -- Definition and best practices for wireflow artifacts.

[19] Buley, L. "The User Experience Team of One." Rosenfeld Media, 2013. -- Practical guide to wireframe fidelity levels.

[20] "Figma Dev Mode Documentation." Figma, 2024. https://www.figma.com/dev-mode/ -- Design-to-development handoff tooling.

[21] "Design Tokens W3C Community Group." W3C, 2024. https://www.w3.org/community/design-tokens/ -- Emerging standard for design token format.

[22] Curtis, N. "Modular Web Design." New Riders, 2010 + "Design Systems" blog series (EightShapes). -- Component library methodology.

[23] "Storybook Documentation." Storybook, 2024. https://storybook.js.org/ -- Component documentation and testing tool.

[24] Content Design London. "Content Design." 2017. -- Content design methodology including content matrices.

[25] "Mailchimp Content Style Guide." Mailchimp. https://styleguide.mailchimp.com/ -- Industry-standard voice and tone guidelines.

[26] Handoff best practices synthesized from multiple industry sources: InVision "Design Better" series, Zeplin documentation, Figma Dev Mode guides, 2023-2024.

[27] "Material Design Motion Guidelines." Google, 2024. https://m3.material.io/styles/motion/ -- Animation specification methodology.

[28] Frost, B. "Atomic Design." Self-published, 2016. -- Responsive design methodology and component-based design.

[29] Krug, S. "Rocket Surgery Made Easy." New Riders, 2009. -- Practical usability test planning methodology.

[30] Kohavi, R., Tang, D., Xu, Y. "Trustworthy Online Controlled Experiments." Cambridge University Press, 2020. -- A/B testing methodology.

[31] "Avo Analytics Governance Platform." Avo, 2024. -- Analytics instrumentation planning and event taxonomy methodology.

[32] "Designing for Every State." Scott Hurff, 2014-2015 (blog series and book "Designing Products People Love"). -- Comprehensive UI state taxonomy.

[33] "Web Content Accessibility Guidelines (WCAG) 2.2." W3C, 2023. https://www.w3.org/TR/WCAG22/ -- Accessibility standard specifications.

[34] "Internationalization Best Practices." W3C. https://www.w3.org/International/ -- i18n specification methodology.

[35] Kadlec, T. "Web Performance Budget." Various articles, 2023-2024. -- Performance budget methodology and enforcement strategies.

[36] Google. "Search Central Documentation." Google, 2024. https://developers.google.com/search/docs -- SEO requirements and technical specifications.

---

**Methodology Note:** This research was compiled from established UX/product design literature and industry-standard frameworks from Nielsen Norman Group, IDEO, the UK Design Council, Interaction Design Foundation, and contemporary design systems thinking. The frameworks and artifact categories described are well-established and stable across the industry, with the core methodologies unchanged since their original publications. The tool recommendations (Figma, Storybook, etc.) reflect the industry landscape as of early 2025. Confidence is assessed as "High" for all sections because each is grounded in multiple established references rather than emerging or contested practices.
