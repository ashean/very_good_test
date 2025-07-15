const { test, expect } = require('@playwright/test');

test('Debug Flutter App - Examine page structure', async ({ page }) => {
  // Navigate to the deployed app
  await page.goto('https://ashean.github.io/very_good_test/');
  
  // Wait for Flutter to load
  await page.waitForLoadState('networkidle');
  await page.waitForTimeout(5000); // Give Flutter extra time
  
  // Take initial screenshot
  await page.screenshot({ path: 'debug-initial.png', fullPage: true });
  
  // Check page title
  const title = await page.title();
  console.log('Page title:', title);
  
  // Check page content
  const bodyText = await page.textContent('body');
  console.log('Page body text:', bodyText?.substring(0, 500));
  
  // Check for Flutter elements
  const flutterElements = await page.$$('flt-glass-pane, flutter-view, [flt-renderer]');
  console.log(`Found ${flutterElements.length} Flutter elements`);
  
  // Check for all clickable elements
  const clickableElements = await page.$$('*[role="button"], button, a, [tabindex="0"]');
  console.log(`Found ${clickableElements.length} clickable elements`);
  
  // Check semantic elements
  const semanticElements = await page.$$('flt-semantics, [flt-semantics-container]');
  console.log(`Found ${semanticElements.length} semantic elements`);
  
  // Get all semantic elements with their text
  const semanticTexts = await page.$$eval('flt-semantics', elements => 
    elements.map(el => ({
      role: el.getAttribute('role'),
      text: el.textContent,
      id: el.id,
      ariaLabel: el.getAttribute('aria-label')
    }))
  );
  
  console.log('Semantic elements:', JSON.stringify(semanticTexts, null, 2));
  
  // Check for input elements
  const inputElements = await page.$$('input, textarea');
  console.log(`Found ${inputElements.length} input elements`);
  
  // Try to find text content that might indicate counter
  const allText = await page.evaluate(() => {
    const walker = document.createTreeWalker(
      document.body,
      NodeFilter.SHOW_TEXT,
      null,
      false
    );
    
    const textNodes = [];
    let node;
    while (node = walker.nextNode()) {
      if (node.nodeValue.trim()) {
        textNodes.push(node.nodeValue.trim());
      }
    }
    return textNodes;
  });
  
  console.log('All text content:', allText);
  
  // Check for any elements with numeric content
  const numericElements = await page.$$eval('*', elements => 
    elements.filter(el => /^\d+$/.test(el.textContent?.trim()))
           .map(el => ({
             tag: el.tagName,
             text: el.textContent,
             id: el.id,
             class: el.className
           }))
  );
  
  console.log('Numeric elements:', JSON.stringify(numericElements, null, 2));
});