const cfg = {
    env: process.env.NODE_ENV || 'dev',
    port: 80,
    mongo: {
        uri: process.env.MONGODB_URI || 'mongodb://localhost/euricomsite',
    },
};

module.exports = cfg;
