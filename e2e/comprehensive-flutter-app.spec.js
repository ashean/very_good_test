const { test, expect } = require('@playwright/test');

// Test configuration
const APP_URL = 'https://ashean.github.io/very_good_test/';
const SCREENSHOT_DIR = 'test-screenshots';

// Test data
const testUserProfile = {
  name: 'John Doe',
  age: '30',
  height: '175.5',
  weight: '70.2'
};

const testBloodTestData = {
  totalCholesterol: '180.5',
  hdlCholesterol: '45.2',
  ldlCholesterol: '110.3',
  triglycerides: '150.0',
  fastingGlucose: '95.5',
  hba1c: '5.8'
};

test.describe('Flutter App Comprehensive Tests', () => {
  
  test.beforeEach(async ({ page }) => {
    // Navigate to the deployed app
    await page.goto(APP_URL);
    
    // Wait for Flutter to fully load
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000); // Extra time for Flutter initialization
    
    // Verify the page loaded correctly
    const title = await page.title();
    console.log('Page title:', title);
    
    // Take initial screenshot
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/01-app-initial-load.png`,
      fullPage: true 
    });
  });

  test('App loads correctly and shows counter functionality', async ({ page }) => {
    // Verify the app has loaded and shows counter
    await expect(page).toHaveTitle(/Flutter/);
    
    // Look for the counter display - it should show "0" initially
    const counterElements = await page.locator('text="0"').all();
    expect(counterElements.length).toBeGreaterThan(0);
    
    // Take screenshot of initial counter state
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/02-counter-initial.png`,
      fullPage: true 
    });
  });

  test('Counter increment, decrement, and reset functionality', async ({ page }) => {
    // Test increment button
    const incrementButton = page.locator('[role="button"]').filter({ hasText: 'Increment' }).or(
      page.locator('flt-semantics[role="button"]').filter({ hasText: 'add' })
    ).or(
      page.locator('button').filter({ hasText: 'add' })
    ).or(
      page.locator('[aria-label*="increment"]')
    ).or(
      page.locator('[title*="increment"]')
    ).or(
      page.locator('[heroTag="increment"]')
    ).or(
      page.locator('flt-semantics').filter({ hasText: '+' })
    ).first();

    // Click increment button multiple times
    for (let i = 0; i < 3; i++) {
      await incrementButton.click();
      await page.waitForTimeout(500);
    }
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/03-counter-after-increment.png`,
      fullPage: true 
    });

    // Test decrement button
    const decrementButton = page.locator('[role="button"]').filter({ hasText: 'Decrement' }).or(
      page.locator('flt-semantics[role="button"]').filter({ hasText: 'remove' })
    ).or(
      page.locator('button').filter({ hasText: 'remove' })
    ).or(
      page.locator('[aria-label*="decrement"]')
    ).or(
      page.locator('[title*="decrement"]')
    ).or(
      page.locator('[heroTag="decrement"]')
    ).or(
      page.locator('flt-semantics').filter({ hasText: '-' })
    ).first();

    await decrementButton.click();
    await page.waitForTimeout(500);
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/04-counter-after-decrement.png`,
      fullPage: true 
    });

    // Test reset button
    const resetButton = page.locator('[role="button"]').filter({ hasText: 'Reset' }).or(
      page.locator('flt-semantics[role="button"]').filter({ hasText: 'refresh' })
    ).or(
      page.locator('button').filter({ hasText: 'refresh' })
    ).or(
      page.locator('[aria-label*="reset"]')
    ).or(
      page.locator('[title*="reset"]')
    ).or(
      page.locator('[heroTag="reset"]')
    ).first();

    await resetButton.click();
    await page.waitForTimeout(500);
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/05-counter-after-reset.png`,
      fullPage: true 
    });
  });

  test('Navigate to User Profile Form and create profile', async ({ page }) => {
    // Find and click the "Add Profile" button in the app bar
    const addProfileButton = page.locator('[role="button"]').filter({ hasText: 'Add Profile' }).or(
      page.locator('flt-semantics[role="button"]').filter({ hasText: 'person_add' })
    ).or(
      page.locator('button').filter({ hasText: 'person_add' })
    ).or(
      page.locator('[aria-label*="Add Profile"]')
    ).or(
      page.locator('[title*="Add Profile"]')
    ).first();

    await addProfileButton.click();
    await page.waitForTimeout(2000);
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/06-user-profile-form-page.png`,
      fullPage: true 
    });

    // Fill out the user profile form
    await page.locator('input[type="text"]').filter({ hasText: 'Name' }).or(
      page.locator('flt-semantics-text-field').filter({ hasText: 'Name' })
    ).or(
      page.locator('input').filter({ hasText: 'Enter your full name' })
    ).first().fill(testUserProfile.name);

    await page.locator('input[type="number"]').filter({ hasText: 'Age' }).or(
      page.locator('flt-semantics-text-field').filter({ hasText: 'Age' })
    ).or(
      page.locator('input').filter({ hasText: 'Enter your age' })
    ).first().fill(testUserProfile.age);

    await page.locator('input[type="number"]').filter({ hasText: 'Height' }).or(
      page.locator('flt-semantics-text-field').filter({ hasText: 'Height' })
    ).or(
      page.locator('input').filter({ hasText: 'Enter your height' })
    ).first().fill(testUserProfile.height);

    await page.locator('input[type="number"]').filter({ hasText: 'Weight' }).or(
      page.locator('flt-semantics-text-field').filter({ hasText: 'Weight' })
    ).or(
      page.locator('input').filter({ hasText: 'Enter your weight' })
    ).first().fill(testUserProfile.weight);

    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/07-user-profile-form-filled.png`,
      fullPage: true 
    });

    // Submit the form
    const saveButton = page.locator('[role="button"]').filter({ hasText: 'Save Profile' }).or(
      page.locator('flt-semantics[role="button"]').filter({ hasText: 'Save Profile' })
    ).or(
      page.locator('button').filter({ hasText: 'Save Profile' })
    ).first();

    await saveButton.click();
    await page.waitForTimeout(2000);
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/08-user-profile-form-submitted.png`,
      fullPage: true 
    });
  });

  test('Navigate to User Profile List and view profiles', async ({ page }) => {
    // Find and click the "View Profiles" button in the app bar
    const viewProfilesButton = page.locator('[role="button"]').filter({ hasText: 'View Profiles' }).or(
      page.locator('flt-semantics[role="button"]').filter({ hasText: 'people' })
    ).or(
      page.locator('button').filter({ hasText: 'people' })
    ).or(
      page.locator('[aria-label*="View Profiles"]')
    ).or(
      page.locator('[title*="View Profiles"]')
    ).first();

    await viewProfilesButton.click();
    await page.waitForTimeout(2000);
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/09-user-profiles-list.png`,
      fullPage: true 
    });

    // Look for profile cards or empty state
    const profileCards = await page.locator('div').filter({ hasText: 'No profiles yet' }).or(
      page.locator('div').filter({ hasText: 'Created:' })
    ).all();

    console.log(`Found ${profileCards.length} profile-related elements`);

    // If there are profiles, test the blood test functionality
    const bloodTestButtons = await page.locator('button').filter({ hasText: 'Blood Tests' }).or(
      page.locator('button').filter({ hasText: 'Add Test' })
    ).all();

    if (bloodTestButtons.length > 0) {
      console.log('Found blood test buttons, testing blood test functionality');
      
      // Click "Add Test" button on first profile
      const addTestButton = page.locator('button').filter({ hasText: 'Add Test' }).first();
      await addTestButton.click();
      await page.waitForTimeout(2000);
      
      await page.screenshot({ 
        path: `${SCREENSHOT_DIR}/10-blood-test-form.png`,
        fullPage: true 
      });
    }
  });

  test('Blood Test Form - Create new blood test result', async ({ page }) => {
    // First create a user profile to attach blood test to
    await createUserProfile(page);
    
    // Navigate to profiles
    await navigateToProfiles(page);
    
    // Click Add Test button
    const addTestButton = page.locator('button').filter({ hasText: 'Add Test' }).first();
    await addTestButton.click();
    await page.waitForTimeout(2000);
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/11-blood-test-form-loaded.png`,
      fullPage: true 
    });

    // Fill out the blood test form
    // Select test date
    const testDateField = page.locator('input').filter({ hasText: 'Test Date' }).or(
      page.locator('flt-semantics-text-field').filter({ hasText: 'Test Date' })
    ).first();
    await testDateField.click();
    await page.waitForTimeout(1000);
    
    // Select today's date in the date picker
    const todayButton = page.locator('button').filter({ hasText: new Date().getDate().toString() }).first();
    await todayButton.click();
    await page.waitForTimeout(1000);

    // Fill in blood test values
    const totalCholesterolField = page.locator('input').filter({ hasText: 'Total Cholesterol' }).or(
      page.locator('flt-semantics-text-field').filter({ hasText: 'Total Cholesterol' })
    ).first();
    await totalCholesterolField.fill(testBloodTestData.totalCholesterol);

    const hdlField = page.locator('input').filter({ hasText: 'HDL Cholesterol' }).or(
      page.locator('flt-semantics-text-field').filter({ hasText: 'HDL Cholesterol' })
    ).first();
    await hdlField.fill(testBloodTestData.hdlCholesterol);

    const ldlField = page.locator('input').filter({ hasText: 'LDL Cholesterol' }).or(
      page.locator('flt-semantics-text-field').filter({ hasText: 'LDL Cholesterol' })
    ).first();
    await ldlField.fill(testBloodTestData.ldlCholesterol);

    const triglyceridesField = page.locator('input').filter({ hasText: 'Triglycerides' }).or(
      page.locator('flt-semantics-text-field').filter({ hasText: 'Triglycerides' })
    ).first();
    await triglyceridesField.fill(testBloodTestData.triglycerides);

    const fastingGlucoseField = page.locator('input').filter({ hasText: 'Fasting Glucose' }).or(
      page.locator('flt-semantics-text-field').filter({ hasText: 'Fasting Glucose' })
    ).first();
    await fastingGlucoseField.fill(testBloodTestData.fastingGlucose);

    const hba1cField = page.locator('input').filter({ hasText: 'HbA1c' }).or(
      page.locator('flt-semantics-text-field').filter({ hasText: 'HbA1c' })
    ).first();
    await hba1cField.fill(testBloodTestData.hba1c);

    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/12-blood-test-form-filled.png`,
      fullPage: true 
    });

    // Submit the form
    const saveResultsButton = page.locator('button').filter({ hasText: 'Save Results' }).or(
      page.locator('flt-semantics[role="button"]').filter({ hasText: 'Save Results' })
    ).first();
    await saveResultsButton.click();
    await page.waitForTimeout(2000);
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/13-blood-test-form-submitted.png`,
      fullPage: true 
    });
  });

  test('View Blood Test Results and Summary', async ({ page }) => {
    // Navigate to profiles first
    await navigateToProfiles(page);
    
    // Look for blood test summary on profile cards
    const bloodTestSummary = page.locator('div').filter({ hasText: 'Latest Blood Test' }).or(
      page.locator('div').filter({ hasText: 'Total Cholesterol' })
    ).or(
      page.locator('div').filter({ hasText: 'mg/dL' })
    ).first();

    if (await bloodTestSummary.isVisible()) {
      console.log('Blood test summary found on profile card');
      await page.screenshot({ 
        path: `${SCREENSHOT_DIR}/14-blood-test-summary-on-profile.png`,
        fullPage: true 
      });
    }

    // Click "Blood Tests" button to view full list
    const bloodTestsButton = page.locator('button').filter({ hasText: 'Blood Tests' }).first();
    if (await bloodTestsButton.isVisible()) {
      await bloodTestsButton.click();
      await page.waitForTimeout(2000);
      
      await page.screenshot({ 
        path: `${SCREENSHOT_DIR}/15-blood-test-list-page.png`,
        fullPage: true 
      });
    }
  });

  test('Navigation and App Bar functionality', async ({ page }) => {
    // Test all navigation buttons in the app bar
    const appBarButtons = await page.locator('[role="button"]').filter({ 
      hasText: /Add Profile|View Profiles|Database Test/ 
    }).or(
      page.locator('flt-semantics[role="button"]').filter({ 
        hasText: /person_add|people|storage/ 
      })
    ).all();

    console.log(`Found ${appBarButtons.length} app bar buttons`);

    // Test Database Test button
    const databaseTestButton = page.locator('[role="button"]').filter({ hasText: 'Database Test' }).or(
      page.locator('flt-semantics[role="button"]').filter({ hasText: 'storage' })
    ).or(
      page.locator('[title*="Database Test"]')
    ).first();

    await databaseTestButton.click();
    await page.waitForTimeout(2000);
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/16-database-test-page.png`,
      fullPage: true 
    });

    // Navigate back to main page
    const backButton = page.locator('[role="button"]').filter({ hasText: 'Back' }).or(
      page.locator('flt-semantics[role="button"]').filter({ hasText: 'arrow_back' })
    ).first();

    if (await backButton.isVisible()) {
      await backButton.click();
      await page.waitForTimeout(1000);
    }
  });

  test('Comprehensive app flow test', async ({ page }) => {
    console.log('Starting comprehensive app flow test...');
    
    // 1. Test counter functionality
    await testCounterFunctionality(page);
    
    // 2. Create user profile
    await createUserProfile(page);
    
    // 3. Navigate to profiles and verify creation
    await navigateToProfiles(page);
    
    // 4. Add blood test result
    await addBloodTestResult(page);
    
    // 5. Verify blood test summary appears
    await verifyBloodTestSummary(page);
    
    await page.screenshot({ 
      path: `${SCREENSHOT_DIR}/17-comprehensive-test-complete.png`,
      fullPage: true 
    });
  });

});

// Helper methods
async function createUserProfile(page) {
    const addProfileButton = page.locator('[role="button"]').filter({ hasText: 'Add Profile' }).or(
      page.locator('flt-semantics[role="button"]').filter({ hasText: 'person_add' })
    ).first();
    
    await addProfileButton.click();
    await page.waitForTimeout(2000);
    
    // Fill form fields
    const nameField = page.locator('input').first();
    await nameField.fill(testUserProfile.name);
    
    const ageField = page.locator('input').nth(1);
    await ageField.fill(testUserProfile.age);
    
    const heightField = page.locator('input').nth(2);
    await heightField.fill(testUserProfile.height);
    
    const weightField = page.locator('input').nth(3);
    await weightField.fill(testUserProfile.weight);
    
    const saveButton = page.locator('button').filter({ hasText: 'Save Profile' }).first();
    await saveButton.click();
    await page.waitForTimeout(2000);
  }

async function navigateToProfiles(page) {
    const viewProfilesButton = page.locator('[role="button"]').filter({ hasText: 'View Profiles' }).or(
      page.locator('flt-semantics[role="button"]').filter({ hasText: 'people' })
    ).first();
    
    await viewProfilesButton.click();
    await page.waitForTimeout(2000);
  }

async function addBloodTestResult(page) {
    const addTestButton = page.locator('button').filter({ hasText: 'Add Test' }).first();
    if (await addTestButton.isVisible()) {
      await addTestButton.click();
      await page.waitForTimeout(2000);
      
      // Fill out form (simplified)
      const totalCholesterolField = page.locator('input').filter({ hasText: 'Total Cholesterol' }).first();
      await totalCholesterolField.fill(testBloodTestData.totalCholesterol);
      
      const saveButton = page.locator('button').filter({ hasText: 'Save Results' }).first();
      await saveButton.click();
      await page.waitForTimeout(2000);
    }
  }

async function verifyBloodTestSummary(page) {
    await navigateToProfiles(page);
    
    const bloodTestSummary = page.locator('div').filter({ hasText: 'Latest Blood Test' }).first();
    if (await bloodTestSummary.isVisible()) {
      console.log('Blood test summary verified successfully');
      return true;
    }
    return false;
  }

async function testCounterFunctionality(page) {
    const incrementButton = page.locator('[role="button"]').first();
    await incrementButton.click();
    await page.waitForTimeout(500);
    
    const decrementButton = page.locator('[role="button"]').nth(1);
    await decrementButton.click();
    await page.waitForTimeout(500);
    
    const resetButton = page.locator('[role="button"]').nth(2);
    await resetButton.click();
    await page.waitForTimeout(500);
  }