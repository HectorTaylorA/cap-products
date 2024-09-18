const cds = require("@sap/cds");
const { data } = require("@sap/cds/lib/dbs/cds-deploy");
const { Orders } = cds.entities("com.training");

module.exports = (srv) => {

    //***********        CDL                *************//

    srv.before("*", (req) => {
        console.log(`Method: ${req.method}`);
        console.log(`Target: ${req.target}`);
    });

    //*********** Operación de lectura Read **************//
    srv.on("READ", "Orders", async (req) => {

        if (req.data.ClientEmail !== undefined) {

            return await SELECT.from`com.training.Orders`.where`ClientEmail = ${req.data.ClientEmail}`;
        }

        return await SELECT.from(Orders);
    });

    //*********** Operación de lectura After **************//
    srv.after("READ", "Orders", (data) => {
        return data.map((orders) => (orders.Reviewed = true));

    });
    //*********** Operación de CREATE **************//
    srv.on("CREATE", "Orders", async (req) => {

        let returnData = await cds.transaction(req)
            .run(
                INSERT.into(Orders).entries({

                    ClientEmail: req.data.ClientEmail,
                    FirstName: req.data.FirstName,
                    LastName: req.data.LastName,
                    CreatedOn: req.data.CreatedOn,
                    Reviewed: req.data.Reviewed,
                    Approved: req.data.Approved,
                    Country_code: req.data.Country_code,
                    Status: req.data.Status,
                })
            )
            .then((resolve, reject) => {
                console.log("Resolve", resolve);
                console.log("Reject", reject);

                if (typeof resolve !== undefined) {
                    return req.data;
                } else {
                    req.error(409, "Record not inserted")
                }
            })
            .catch((err) => {
                console.log(err);
                req.error(err.code, err.message);
            });
        console.log("Before End", returnData);
        return returnData;
    });

    //*********** Operación Before agregar valores antes del insert **************//
    srv.before("CREATE", "Orders", (req) => {
        req.data.CreatedOn = new Date().toISOString().slice(0, 10);

        return req;
    });

    //*********** Operación UPDATE **************//
    srv.on("UPDATE", "Orders", async (req) => {
        let returnData = await cds.transaction(req).run(
            [
                UPDATE(Orders, req.data.ClientEmail).set({
                    FirstName: req.data.FirstName,
                    LastName: req.data.LastName,

                }) //{key1 : valor, key2 : valor2 }
            ]
        ).then((resolve, reject) => {
            console.log("Resolve", resolve);
            console.log("Reject", reject);

            if (resolve[0] == 0) {
                req.error(409, "Record not Found")
            }

        }).catch((err) => {
            console.log(err);
            req.error(err.code, err.message);
        });
        console.log("Before End", returnData);
        return returnData;
    });

    //*********** Operación DELETE **************//
    srv.on("DELETE", "Orders", async (req) => {

        let returnData = await cds.transaction(req).run(
            DELETE.from(Orders).where({
                ClientEmail: req.data.ClientEmail,
            })
        ).then((resolve, reject) => {
            console.log("Resolve", resolve);
            console.log("Reject", reject);

            if (resolve !== 1) {
                req.error(409, "Record not Found")
            }

        }).catch((err) => {
            console.log(err);
            req.error(err.code, err.message);
        });
        console.log("Before End", returnData);
        return await returnData;
    });

    //*********** Function  **************//
    srv.on("getClientTaxRate", async (req) => {
        // No Server Side Effect 
        const { ClientEmail } = req.data;
        const db = srv.transaction(req);

        const results = await db.read(Orders, ["Country_code"]).where({ ClientEmail: ClientEmail });

        console.log(results[0]);
        switch (results[0].Country_code) {
            case 'ES':
                return 21.5;
                break;
            case 'UK':
                return 24.6;
                break;
            default:
                break;
        }
    });
    //*********** Action  **************//
    srv.on("cancelOrder", async (req) => {
        const { ClientEmail } = req.data;
        const db = srv.transaction(req);

        const resultRead = await db.read(Orders, ["FirstName", "LastName", "Approved"]).where({ ClientEmail: ClientEmail });

        let returnOrder = {
            status: "",
            message: ""
        };

        console.log(ClientEmail);
        console.log(resultRead);

        if (resultRead[0].Approved == false) {
            const resultUpdate = await db.update(Orders).set({ Status: 'C' }).where({ ClientEmail: ClientEmail });
            returnOrder.status = "Succeded";
            returnOrder.message = `The Order placed by ${resultRead[0].FirstName} ${resultRead[0].LastName} was cancel`;
        } else {
            returnOrder.status = "Failed";
            returnOrder.message = `The Order placed by ${resultRead[0].FirstName} ${resultRead[0].LastName} was Not cancel becouse was already approved`;
        }
        console.log("Action Cancel Order Executed");
        return returnOrder;

    })
};