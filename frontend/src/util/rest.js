async function get( url ) {

  const response = await fetch( url )
  const json = await response.json()

  return json

}

async function post( url, data ) {
  const opts = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify( data )
  }

  const response = await fetch( url, opts )
  const json = await response.json()

  return json

}

export default {
  get,
  post
}