part of lib_test;

Map serverRoute = {
    "V101": { // create group
        "handler": TestRouteLogic.createGroup,
        "params": {
            "n": "rs",
        },
        "locks": [],
        "encryptType": null,
        "reqEncrypt": false,
        "resEncrypt": false,
    },
};
