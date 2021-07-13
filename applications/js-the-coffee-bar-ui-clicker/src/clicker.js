const puppeteer = require('puppeteer');
const utils = require('./utils')
require('console-stamp')( console );

const UI_URL_ARG = process.argv.slice(2);
const COFFEE_BAR_UI_URL = UI_URL_ARG[0] || process.env.COFFEE_BAR_UI_URL || 'http://the-coffee-bar-frontend:3000'; // The Coffee Bar UI URL
const DELAY = parseInt(process.env.CLICKER_INTERVAL) || 5; // Browser sleep interval in seconds

const SELECTORS = {
    'coffee': 'select[name="coffee"]',
    'coffeeAmount': 'input[name="amount"]',
    'water': 'input[name="water"]',
    'grains': 'input[name="grains"]',
    'sweets': 'select[name="sweets"]',
    'sweetsAmount': 'input[name="sweets_amount"]',
    'bill': 'input[name="bill"]',
    'orderBtn': 'button[type="order"]'
};
const COFFEE = ['americano', 'cappuccino', 'espresso'];
const SWEETS = ['cannolo_siciliano', 'cheesecake', 'cornetto', 'torta', 'muffin_alla_ricotta', 'budini_fiorentini',
    'tiramisu'];

const NAVIGATE_RETRY_SECONDS = 60 * 1000;

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

        async function clickAndSelect(selector, value) {
            console.info(`Setting value: ${value} for: ${selector}`);
            await page.select(selector, value);
        }

        // Navigate to The Coffee Bar UI
        await utils.retry(() => page.goto(COFFEE_BAR_UI_URL), NAVIGATE_RETRY_SECONDS);

        await utils.sleep(DELAY)
        // Select Coffee to order
        await clickAndSelect(SELECTORS['coffee'], utils.getItemFromList(COFFEE));
        // Set Coffee amount
        await clickAndSetFieldValue(SELECTORS['coffeeAmount'], utils.getRandomNumber(-1, 3))
        // Set Water amount
        await clickAndSetFieldValue(SELECTORS['water'], utils.getRandomNumber(-5, 50));
        // Set Grains amount
        await clickAndSetFieldValue(SELECTORS['grains'], utils.getRandomNumber(-5, 50));
        // Selet Sweets to order
        await clickAndSelect(SELECTORS['sweets'], utils.getItemFromList(SWEETS));
        // Set Sweets amount
        await clickAndSetFieldValue(SELECTORS['sweetsAmount'], utils.getRandomNumber(1, 3));
        // Set Bill amount
        await clickAndSetFieldValue(SELECTORS['bill'], utils.getRandomNumber(1, 20));

        // Order
        console.info('Click order button')
        await page.click('button[type="order"]');

        // Dismiss dialog
        page.on('dialog', async dialog => {
            console.info(dialog.message());
            await dialog.dismiss();
        });

        await utils.sleep(DELAY)
        await browser.close();

    }
})();
