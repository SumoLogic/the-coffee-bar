const puppeteer = require('puppeteer');

const utils = require('./utils')
require('console-stamp')(console);

const UI_URL_ARG = process.argv.slice(2);
const COFFEE_BAR_UI_URL = UI_URL_ARG[0] || process.env.COFFEE_BAR_UI_URL || 'http://the-coffee-bar-frontend:3000'; // The Coffee Bar UI URL
const DELAY = parseInt(process.env.CLICKER_INTERVAL) || 5; // Browser sleep interval in seconds
const BROWSER = process.env.PUPPETEER_PRODUCT || 'chrome'
const DEBUG_DUMPIO_ENV = process.env.DEBUG_DUMPIO || false

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
    console.info(`BROWSER=${BROWSER}`);
    console.info(`DEBUG_DUMPIO_ENV=${DEBUG_DUMPIO_ENV}`);


    while (true) {
        console.info('Starting new browser');

        let executablePath = null;
        if (BROWSER === 'firefox') {
            executablePath = process.env.FIREFOX_BIN
        } else {
            executablePath = process.env.CHROME_BIN
        }

        let dumpio_debug = null;
        if (DEBUG_DUMPIO_ENV === 'false') {
            dumpio_debug = false;
        } else {
            dumpio_debug = true;
        }
        var browser = null;
        var page = null;
        try {
            browser = await puppeteer.launch({
                executablePath: executablePath,
                headless: true,
                dumpio: dumpio_debug,
                slowMo: 250,
                devtools: false,
                args: ['--devtools-flags=disable','--disable-software-rasterizer','--disable-extensions', '--wait-for-browser', '--disable-gpu', '--no-sandbox', '--disable-dev-shm-usage', '--disable-web-security'],
            });
            
            page = await browser.newPage();

            async function clickAndSetFieldValue(selector, value, del) {
                console.info(`Setting value: ${value} for: ${selector}`);
                await page.waitForSelector(selector, {timeout: del * 1000});
                await page.click(selector);
                await page.type(selector, String(value), {delay: utils.getRandomNumber(1000, 2000)});
            }

            async function click(selector, del) {
                console.info(`Clicking on: ${selector}`);
                await page.waitForSelector(selector, {timeout: del * 1000});
                await page.click(selector);
            }

            // Navigate to The Coffee Bar UI
            await utils.retry(() => page.goto(COFFEE_BAR_UI_URL), NAVIGATE_RETRY_SECONDS);

            // Select Coffee to order
            let coffee = utils.getItemFromList(COFFEE);
            let coffee_selectors = {
                'input': `input[name="${coffee}"]`,
                'button': `button[name="${coffee}"]`,
            }

            // Set Coffee amount
            await clickAndSetFieldValue(coffee_selectors['input'], utils.getRandomNumber(0, 3), DELAY);
            // Add Coffee
            await click(coffee_selectors['button'], DELAY);

            // Select Coffee to order
            let sweets = utils.getItemFromList(SWEETS);
            let sweet_selectors = {
                'input': `input[name="${sweets}"`,
                'button': `button[name="${sweets}"`,
            }

            // Set Sweets amount
            await clickAndSetFieldValue(sweet_selectors['input'], utils.getRandomNumber(1, 3), DELAY);
            // Add Sweets
            await click(sweet_selectors['button'], DELAY);


            // Checkout
            await click(GLOBAL_SELECTORS['checkoutBtn'], DELAY)

            // Add bill
            await clickAndSetFieldValue(GLOBAL_SELECTORS['billInput'], utils.getRandomNumber(1, 20), DELAY);

            // Pay
            await click(GLOBAL_SELECTORS['payBtn'], DELAY);

            // Order Status ok
            if (BROWSER === 'firefox') {
                await utils.sleep(DELAY + 10);
            } else {
                await click(GLOBAL_SELECTORS['okBtn'], DELAY);
            }
        }
        catch (err) {
            console.error(err);
        }
        finally {
            await page.close();
            await browser.close();
        }
    }
})();
