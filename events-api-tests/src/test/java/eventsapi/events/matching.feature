@subscriptions
Feature: Match Testing

	Background:
		* url 'http://localhost:8080/api'
		* def authFeature = callonce read('authentication.feature')
		* def access_token = authFeature.access_token
		
	Scenario: Subscriptions
		Given path 'subscriptions'
		And header Authorization = 'Bearer ' + access_token
		When method get
		Then status 200
		
		* match response == { success: '#boolean', statusCode: '#number', errorMessage: '##string', data: '#array'}
		
		* match response.data[*] contains { id: '#number', userId: '#number', eventId: '#number', createdAt: '#number', userAccount: { id: '#number', firstName: '#string', lastName: '#string', email: '#regex ^[\\w.%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$' }, event: { id: '#number', name: '#string', description: '#string', currentCapacity: '#number', date: '#number', location: '#string', maxCapacity: '#number', numberOfHours: '#number', organizer: '#string', startTime: "#string", userId: '#number' } }
		
		* match response.data[*].id contains '#number'