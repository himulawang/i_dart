part of lib_test;

Map route = {
    "V101": { // create group
        "handler": GroupLogic.createGroup,
        "params": {
            "n": "rs",
        },
        "locks": [],
        "encryptType": null,
        "reqEncrypt": false,
        "resEncrypt": false,
    },
    "V102": { // create group
        "handler": GroupLogic.createGroup,
        "params": {
            "n": "rs",
        },
        "locks": [],
        "encryptType": null,
        "reqEncrypt": false,
        "resEncrypt": false,
    }
};
