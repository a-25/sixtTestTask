class CarListModuleConfigurator {
    func createCarListController() -> CarListViewController {
        return CarListViewController(carDatasource: DI.carDatasource,
                                     errorMessageService: DI.carErrorMessageService,
                                     imageLoader: DI.imageLoader)
    }
}
