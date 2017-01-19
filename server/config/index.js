const cfg = {
    env: process.env.NODE_ENV || 'dev',
    port: process.env.PORT || 3000,
    mongo: {
        uri: process.env.MONGODB_URI || 'mongodb://localhost/euricomsite',
    },
};

module.exports = cfg;
