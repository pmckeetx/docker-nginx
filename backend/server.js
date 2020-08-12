const ronin 		= require( 'ronin-server' )
const mocks 		= require( 'ronin-mocks' )
const database	= require( 'ronin-database' )

async function main() {

	try {

    const server = ronin.server({
			port: process.env.PORT || 8080
		})

		server.use( '/services/m/', mocks.server( server.Router(), false, true ) )

    const result = await server.start()
    console.info( result )

	} catch( error ) {
		console.error( error )
	}

}

function shutdown( signal ) {
	console.info( `[${signal}] shutting down...` )
	process.exit()
}

process.on( 'SIGINT', () => shutdown( 'SIGINT' ) )
process.on( 'SIGTERM', () => shutdown( 'SIGTERM' ) )

main()
