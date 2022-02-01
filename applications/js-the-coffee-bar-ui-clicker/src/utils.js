const util = require('util');

const delay = util.promisify(setTimeout);
require('console-stamp')(console);

module.exports = {
    getItemFromList: function (list) {
        return list[Math.floor((Math.random() * list.length))];
    },

    sleep: async function (seconds) {
        return new Promise(resolve => setTimeout(resolve, seconds * 1000));
    },

    getRandomNumber: function (min, max) {
        min = Math.ceil(min);
        max = Math.floor(max);
        return Math.floor(Math.random() * (max - min + 1) + min);
    },

    retry: async (fn, retryDelay = 10, numRetries = 3) => {
        for (let i = 0; i < numRetries; i++) {
            try {
                return await fn()
            } catch (e) {
                console.error(e)
                if (i === numRetries - 1) throw e
                await delay(retryDelay * 1000)
                retryDelay = retryDelay * 2
            }
        }
    },

    getRandomInt(min, max) {
        min = Math.ceil(min);
        max = Math.floor(max);
        return Math.floor(Math.random() * (max - min + 1) + min); //The maximum is inclusive and the minimum is inclusive
    },

    choose(choice) {
        var random = this.getRandomInt(0, 100);

        for (const [key, val] of Object.entries(choice)) {
            if (random >= val[0] && random <= val[1]) {
                return key
            }
        }
    },

    chooseUserAgent(choice) {
        var random = this.getRandomInt(0, 100);
        var system = null;
        var browserVersion = null;

        for (const [key, val] of Object.entries(choice)) {
            if (random >= val['probScope'][0] && random <= val['probScope'][1]) {
                system = val['value'];
                console.info(`Select system: ${system}`);
                random = this.getRandomInt(0, 100);
                for (const [bkey, bval] of Object.entries(val['browsers'])) {
                    if (random >= bval['probScope'][0] && random <= bval['probScope'][1]) {
                        random = this.getRandomInt(0, 100);
                        console.info(`Select browser: ${bkey}`);
                        for (const [vkey, vval] of Object.entries(bval['versions'])) {
                            if (random >= vval['probScope'][0] && random <= vval['probScope'][1]) {
                                browserVersion = vval['value'];

                                console.info(`Select browser version: ${browserVersion}`);
                                break;
                            }
                        }
                        break;
                    }
                }
                break;
            }
        }
        return [system, browserVersion];
    }
}
