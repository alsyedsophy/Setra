# Naming Conventions

## General
Use clear and descriptive names.
Names should explain intent without comments.
Avoid abbreviations.

## Files
Use snake_case.
Examples:
login_screen.dart
product_card.dart
cart_repository_impl.dart

## Classes
Use PascalCase.
Examples:
LoginScreen
ProductRepository
CartCubit

## Variables
Use camelCase.
Examples:
currentUser
selectedColor
totalPrice

## Methods
Methods should start with a verb.
Examples:
login()
logout()
getProducts()
createOrder()
updateProfile()

## Boolean Variables
Always use readable names.
Good:
isLoading
isLoggedIn
hasDiscount
canCheckout
Avoid:
flag
status
check

## Cubits
Format:
FeatureCubit
Examples:
LoginCubit
CartCubit
OrdersCubit

## States
Format:
FeatureState
Examples:
LoginState
CartState
ProfileState

## Repositories
Contract:
ProductsRepository
Implementation:
ProductsRepositoryImpl

## Use Cases
Always end with UseCase.
Examples:
LoginUseCase
GetProductsUseCase
CreateOrderUseCase

## Models
Always end with Model.
Examples:
ProductModel
OrderModel
UserModel

## Entities
Good:
ProductEntity
OrderEntity
CategoryEnity
Bad:
Product
Order

## Data Sources
ProductsRemoteDataSource
ProductsLocalDataSource