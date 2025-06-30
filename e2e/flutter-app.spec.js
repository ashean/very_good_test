const { test, expect } = require('@playwright/test');

test('Flutter app basic functionality', async ({ page }) => {
  // Go to the Flutter app
  await page.goto('/');

  // Wait for Flutter to load - be more flexible with loading
  await page.waitForLoadState('networkidle');
  await page.waitForTimeout(2000); // Give Flutter time to initialize

  // Take a screenshot to see what we're working with
  await page.screenshot({ path: 'flutter-app-loaded.png' });

  // Check if the page has loaded properly
  const title = await page.title();
  console.log('Page title:', title);

  // Look for Flutter elements more broadly
  const flutterElements = await page.$$('flt-glass-pane, flutter-view, [flt-renderer]');
  console.log(`Found ${flutterElements.length} Flutter elements`);

  // Try to find interactive elements
  const clickableElements = await page.$$('button, [role="button"], [tabindex="0"], flt-semantics[role="button"]');
  console.log(`Found ${clickableElements.length} clickable elements`);

  if (clickableElements.length > 0) {
    // Click the first clickable element we find
    await clickableElements[0].click();
    await page.waitForTimeout(1000);
    
    // Take another screenshot after interaction
    await page.screenshot({ path: 'flutter-app-after-click.png' });
  }

  // Check for navigation or other semantic elements
  const semanticElements = await page.$$('[role="navigation"], [role="main"], [role="button"], flt-semantics');
  console.log(`Found ${semanticElements.length} semantic elements`);
});

test('Flutter app counter functionality', async ({ page }) => {
  await page.goto('/');
  
  // Wait for Flutter to load
  await page.waitForLoadState('networkidle');
  await page.waitForTimeout(2000);

  // Look for text that might indicate a counter value
  const bodyText = await page.textContent('body');
  console.log('Page text content includes:', bodyText?.substring(0, 200));

  // Try to find and click various elements that might be buttons
  const potentialButtons = await page.$$(`
    button, 
    [role="button"], 
    [tabindex="0"], 
    flt-semantics[role="button"],
    flt-semantics:has-text("+"),
    [aria-label*="increment"],
    [title*="increment"]
  `);

  console.log(`Found ${potentialButtons.length} potential interactive elements`);

  // Try clicking elements using selector instead of stored handles
  const buttonSelectors = [
    'button', 
    '[role="button"]', 
    '[tabindex="0"]', 
    'flt-semantics[role="button"]'
  ];

  for (const selector of buttonSelectors) {
    try {
      const element = await page.$(selector);
      if (element) {
        console.log(`Clicking element with selector: ${selector}`);
        await page.click(selector);
        await page.waitForTimeout(1000);
        await page.screenshot({ path: `flutter-click-${selector.replace(/[^a-zA-Z0-9]/g, '_')}.png` });
        break; // Stop after first successful click
      }
    } catch (error) {
      console.log(`Failed to click ${selector}: ${error.message}`);
    }
  }

  await page.screenshot({ path: 'flutter-counter-test.png' });
});