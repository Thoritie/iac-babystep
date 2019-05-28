describe ('New Pronto World Template', () => {

    context('Account', () => {

        it('View Admin', () => {
            cy.visit('/admin')
            cy.get(':nth-child(2) > .required').contains('Username:')
            cy.get(':nth-child(3) > .required').contains('Password:')
        })
    })
})

