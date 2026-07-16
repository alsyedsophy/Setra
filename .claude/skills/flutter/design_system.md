---
name: Setra Premium
colors:
  surface: '#f9f9f9'
  surface-dim: '#dadada'
  surface-bright: '#f9f9f9'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f4'
  surface-container: '#eeeeee'
  surface-container-high: '#e8e8e8'
  surface-container-highest: '#e2e2e2'
  on-surface: '#1a1c1c'
  on-surface-variant: '#4c4546'
  inverse-surface: '#2f3131'
  inverse-on-surface: '#f0f1f1'
  outline: '#7e7576'
  outline-variant: '#cfc4c5'
  surface-tint: '#5e5e5e'
  primary: '#000000'
  on-primary: '#ffffff'
  primary-container: '#1b1b1b'
  on-primary-container: '#848484'
  inverse-primary: '#c6c6c6'
  secondary: '#5e5e5e'
  on-secondary: '#ffffff'
  secondary-container: '#e3e2e2'
  on-secondary-container: '#646464'
  tertiary: '#000000'
  on-tertiary: '#ffffff'
  tertiary-container: '#1a1c1c'
  on-tertiary-container: '#838484'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e2e2e2'
  primary-fixed-dim: '#c6c6c6'
  on-primary-fixed: '#1b1b1b'
  on-primary-fixed-variant: '#474747'
  secondary-fixed: '#e3e2e2'
  secondary-fixed-dim: '#c7c6c6'
  on-secondary-fixed: '#1b1c1c'
  on-secondary-fixed-variant: '#464747'
  tertiary-fixed: '#e2e2e2'
  tertiary-fixed-dim: '#c6c6c7'
  on-tertiary-fixed: '#1a1c1c'
  on-tertiary-fixed-variant: '#454747'
  background: '#f9f9f9'
  on-background: '#1a1c1c'
  surface-variant: '#e2e2e2'
typography:
  display-lg:
    fontFamily: Geist
    fontSize: 64px
    fontWeight: '700'
    lineHeight: '1.1'
    letterSpacing: -0.04em
  display-lg-mobile:
    fontFamily: Geist
    fontSize: 40px
    fontWeight: '700'
    lineHeight: '1.2'
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Geist
    fontSize: 32px
    fontWeight: '600'
    lineHeight: '1.3'
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Geist
    fontSize: 24px
    fontWeight: '600'
    lineHeight: '1.4'
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: '1.5'
  label-caps:
    fontFamily: Geist
    fontSize: 12px
    fontWeight: '600'
    lineHeight: '1.2'
    letterSpacing: 0.1em
  button:
    fontFamily: Geist
    fontSize: 14px
    fontWeight: '500'
    lineHeight: '1'
    letterSpacing: 0.02em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 48px
  xl: 80px
  container-max: 1440px
  gutter: 24px
  margin-mobile: 16px
  margin-desktop: 64px
---

## Brand & Style

The design system is rooted in the concept of "Architectural Minimalism." It is designed for a premium fashion house that treats the hoodie not as casual wear, but as a structural garment of luxury. The brand personality is silent but authoritative—relying on perfect proportions, expansive white space, and high-contrast monochrome aesthetics.

The visual style is **Modern Corporate Minimalism with a Tactile Edge**. It avoids unnecessary ornamentation, allowing high-quality lifestyle photography to serve as the primary visual driver. The interface should feel like a digital boutique: spacious, calm, and effortlessly sophisticated. It balances the "industrial" precision of premium manufacturing with the "human" softness of luxury textiles through subtle shadows and refined radii.

## Colors

This design system utilizes a strict **Monochromatic Palette** to enforce a sense of timelessness and premium positioning. 

- **Pure Black (#000000)** is the primary driver for typography, call-to-action surfaces, and structural boundaries.
- **Pure White (#FFFFFF)** provides the "canvas," ensuring maximum breathing room and highlighting the silhouettes of the apparel.
- **Grayscales** are used functionally: **#333333** for secondary text, **#888888** for tertiary metadata, and **#F5F5F5** for soft background containment and subtle elevation tiers.

Color should never compete with the product. Any non-monochrome color is reserved strictly for critical system feedback (e.g., error states).

## Typography

Typography is used as a structural element. **Geist** provides a technical, precise feel for headlines and functional labels, while **Inter** ensures maximum readability for descriptive body copy.

- **Headlines:** Use tight letter-spacing for large displays to create a bold, "editorial" impact.
- **Arabic Localization:** For Arabic scripts, font-weight should be adjusted slightly lighter than the English equivalent to maintain visual density parity. Line-height must increase by 20% for Arabic body text to accommodate the script's ascenders and descenders.
- **Hierarchy:** Use uppercase labels with generous letter spacing for categories and metadata to distinguish them from standard narrative text.

## Layout & Spacing

The layout philosophy follows a **Fixed-Fluid Hybrid Grid**. On desktop, content is centered within a 1440px container with aggressive outer margins (64px) to create a "gallery" feel. On mobile, margins reduce to 16px to maximize real estate for product imagery.

- **Rhythm:** An 8px base grid governs all spatial relationships.
- **Verticality:** Use `xl` (80px) spacing between major sections to emphasize exclusivity and prevent the interface from feeling crowded.
- **RTL Support:** All horizontal layouts must flip for Arabic. Icons indicating direction (arrows, chevrons) must be mirrored, except for those representing "time" or physical progress.

## Elevation & Depth

This design system uses **Tonal Layering and Soft Shadows** to define depth. Rather than heavy shadows, it relies on slight shifts in background color and extremely diffused, low-opacity shadows.

- **Level 0 (Base):** Pure White (#FFFFFF).
- **Level 1 (Cards/Floating Elements):** Pure White with a "Whisper Shadow" (0px 4px 20px, 4% Black opacity).
- **Level 2 (Active/Modals):** Pure White with a defined soft shadow (0px 10px 30px, 8% Black opacity) and a 1px border of #E5E5E5.
- **Depth Metaphor:** Surfaces should appear as if they are floating slightly above the base, like layers of premium fabric.

## Shapes

The shape language is **Refined and Intentional**. 

- **Standard Radius:** 8px for smaller components like buttons and input fields.
- **Large Radius:** 16px (rounded-lg) for product cards and lifestyle imagery containers.
- **Extra Large:** 24px (rounded-xl) for top-level sheets and drawers.

This "soft-square" approach ensures the UI feels modern and approachable without losing the professional rigor of a luxury brand.

## Components

### Buttons
- **Primary:** Solid Black (#000000) with White text. Rectangular with 8px radius. No gradients.
- **Secondary:** Outlined 1.5px Black or Solid White with a thin Gray-light border.
- **Ghost:** No background, Black text, bold weight. Used for secondary navigation.

### Product Cards
- **Structure:** Edge-to-edge photography at the top. 16px bottom padding for the title and price.
- **Price Styling:** Displayed in `label-caps` for a boutique look.
- **Hover/State:** Subtle scale-up of the image (1.02x) while keeping the container fixed.

### Input Fields
- **Style:** Outlined. 1px border in #E5E5E5.
- **Focus State:** Border transitions to #000000. 
- **Labels:** Floating labels or top-aligned labels in `body-sm`.

### Bottom Sheets
- **Luxury Sheets:** Used for filters and sizing guides on mobile. Featuring a "grabber" handle that is a soft gray (#E5E5E5), 32px wide, and 24px rounded corners at the top of the sheet.

### Navigation
- **Desktop:** Minimal top-bar with center-aligned logo and right-aligned utility icons (Search, Bag, Account).
- **Mobile:** A sleek, sticky bottom-nav or a high-contrast full-screen overlay menu.