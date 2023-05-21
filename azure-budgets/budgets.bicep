targetScope= 'subscription'
@metadata({
  Module : 'Budgets'
  version: '0.1'
  deployBy: 'Jorge Bernhardt'
})

@description('Name of the project or solution')
@minLength(3)
@maxLength(24)
param systemName string = 'demo'

@description('Environments to use')
@allowed([
  'pre'
  'prod'
])
param environment string


@description('Start date in the format yyyy-MM-dd')
param startDate string

@description('End date in the format yyyy-MM-dd')
param endDate string

@description('Maximum budget allowed')
param maximumBudget int

@description('List of contact emails for notifications')
param contactEmails array

var nameBudget = 'budget-sub-${systemName}-${environment}'

resource budget 'Microsoft.Consumption/budgets@2023-03-01' = {
  name: nameBudget
  properties: {
    timeGrain: 'Monthly'
    timePeriod: {
      startDate: startDate
      endDate: endDate
      }
     category: 'Cost'
     amount: maximumBudget
     notifications: {
       Actual_Over_90_Percent:{
         enabled: true
         operator: 'GreaterThanOrEqualTo'
         threshold: 90
         thresholdType: 'Actual'
         contactEmails: contactEmails
        }
        Forecast_Over_80_Percent: {
          enabled:true
          operator: 'GreaterThanOrEqualTo'
          threshold: 80
          thresholdType: 'Forecasted'
          contactEmails: contactEmails     
        }
       }
    }
}
output budgetName string = budget.name
output budgetId string = budget.id

