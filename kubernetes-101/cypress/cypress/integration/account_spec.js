describe ('New Pronto World Template', () => {

    context('Account', () => {

        it('View Admin', () => {
            cy.visit('/admin')
            cy.get('#login-form').contain('action', '/admin/login/?next=/admin/')
        })
    })
})

