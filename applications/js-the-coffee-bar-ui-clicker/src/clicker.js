const puppeteer = require('puppeteer');
const utils = require('./utils')
require('console-stamp')( console );

const UI_URL_ARG = process.argv.slice(2);
const COFFEE_BAR_UI_URL = UI_URL_ARG[0] || process.env.COFFEE_BAR_UI_URL || 'http://the-coffee-bar-frontend:3000'; // The Coffee Bar UI URL
const DELAY = parseInt(process.env.CLICKER_INTERVAL) || 5; // Browser sleep interval in seconds

const GLOBAL_SELECTORS = {
    'checkoutBtn': 'button[name="Checkout"]',
    'okBtn': 'button[name="OkBtn"]',
    'payBtn': 'button[name="Pay"]',
    'billInput': 'input[name="Bill"]',
};

const COFFEE = ['Espresso', 'Cappuccino', 'Americano'];
const SWEETS = ['Tiramisu', 'Cornetto', 'Muffin'];

const NAVIGATE_RETRY_SECONDS = 60;

(async () => {
    console.info('Starting The Coffee Bar UI Clicker');
    console.info(`COFFEE_BAR_UI_URL=${COFFEE_BAR_UI_URL}`);
    console.info(`DELAY=${DELAY}`);

    while (true) {
        console.info('Starting new browser');
        const browser = await puppeteer.launch({
            executablePath: '/usr/bin/chromium-browser',
            headless: true,
            // dumpio: true,
            args: ['--disable-dev-shm-usage', '--disable-gpu', '--disable-browser-side-navigation', '--no-sandbox'],
            //"--remote-debugging-address=0.0.0.0", "--remote-debugging-port=9222"]
        });
        const page = await browser.newPage();

        async function clickAndSetFieldValue(selector, value) {
            console.info(`Setting value: ${value} for: ${selector}`);
            await page.click(selector);
            await page.type(selector, String(value), {delay: utils.getRandomNumber(1000,2000)});
        }

        async function click(selector) {
            console.info(`Clicking on: ${selector}`);
            await page.click(selector);
        }

        // Navigate to The Coffee Bar UI
        await utils.retry(() => page.goto(COFFEE_BAR_UI_URL), NAVIGATE_RETRY_SECONDS);

        await utils.sleep(DELAY)

        // Select Coffee to order
        let coffee = utils.getItemFromList(COFFEE);
        let coffee_selectors = {
            'input': `input[name="${coffee}"]`,
            'button': `button[name="${coffee}"]`,
        }

        // Set Coffee amount
        await clickAndSetFieldValue(coffee_selectors['input'], utils.getRandomNumber(0, 3));
        // Add Coffee
        await click(coffee_selectors['button']);
        
        // Select Coffee to order
        let sweets = utils.getItemFromList(SWEETS);
        let sweet_selectors = {
            'input': `input[name="${sweets}"`,
            'button': `button[name="${sweets}"`,
        }

        // Set Sweets amount
        await clickAndSetFieldValue(sweet_selectors['input'], utils.getRandomNumber(1, 3));
        // Add Sweets
        await click(sweet_selectors['button']);


        // Checkout
        await click(GLOBAL_SELECTORS['checkoutBtn'])

        // Add bill
        await clickAndSetFieldValue(GLOBAL_SELECTORS['billInput'], utils.getRandomNumber(1,20));

        // Pay
        await click(GLOBAL_SELECTORS['payBtn']);

        // Order Status ok
        await utils.sleep(DELAY)
        await click(GLOBAL_SELECTORS['okBtn']);

        await utils.sleep(DELAY)
        await browser.close();
    }
})();
