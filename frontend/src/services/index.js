import config from '../config'
import rest from '../util/rest' 

async function searchEntities( entity ) {
  return await rest.get( `${config.services.host}/${entity}` )
}

async function getById( entity, id ) {
  return await rest.get( `${config.services.host}/${entity}/${id}` )
}

async function createEntity( entity, obj ) {
  return await rest.post( `${config.services.host}/${entity}`, obj )
}

export default {
  searchEntities,
  getById,
  createEntity
}