using {sapbackend as external} from './external/sapbackend.csn';

define service SAPBackendExit {
    // curl -H "Authorization: Basic c2FwdWk1OnNhcHVpNQ==" http://erp13.sap4practice.com:9037/sap/opu/odata/sap/YSAPUI5_SRV_01/$metadata > sapbackend.xml
    // cds import sapbackend.edmx
    @sap.persistence: {
        table,
        skip: false
    }
    @cds.autoexpose
    entity Incidents as projection on external.IncidentsSet;
//entity Incidents as select from external.IncidentsSet;
// {
//     IncidenceId,
//     EmployeeId,
//     '' as NewProperty nueva propiedad para agregar datos que no esta en la entidad

// };
}

@protocol: 'rest'
service RestService {
    entity Incidents as projection on SAPBackendExit.Incidents;
}
