//
//  SummaryCakeViewModel+Mock.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit

extension SummaryCakeViewModel {
    
    static var mockData: SummaryCakeViewModel {
        SummaryCakeViewModel(
            cake: CakeModel(id: "tMqq3tWoyTtkSisEi6pi", price: "1000", description: .description, images: .mockDataImage, seller: .mockData)
        )
    }
}

private extension String {
    
    static let description = """
    Челове́к-пау́к (англ. Spider-Man), настоящее имя Пи́тер Бе́нджамин Па́ркер (англ. Peter Benjamin Parker) — супергерой, появляющийся в комиксах издательства Marvel Comics, созданный Стэном Ли и Стивом Дитко. С момента своего первого появления на страницах комикса Amazing Fantasy № 15 (рус. Удивительная фантазия, август 1962) он стал одним из самых популярных супергероев. Ли и Дитко задумывали персонажа как подростка-сироту, воспитанного дядей и тётей, совмещающего жизнь обычного студента и борца с преступностью. Человек-паук получил суперсилу, увеличенную ловкость, «паучье чутьё», а также способность держаться на отвесных поверхностях и выпускать паутину из рук с использованием прибора собственного изобретения.
    
    До появления Человека-паука в 1960-х подростки в комиксах о супергероях обычно были всего лишь их помощниками. Комиксы о Человеке-пауке разбили эти стереотипы, представив героем одинокого подростка, отвергаемого многими сверстниками[4], у которого не было опытного наставника, как Стив Роджерс у Баки или Бэтмен у Робина. После смерти своего дяди Бена ему пришлось самостоятельно узнавать, что «с большой силой приходит и большая ответственность» (англ. With great power there must also come great responsibility).
    
    Marvel выпустила множество серий комиксов о Человеке-пауке. Самая первая из них — The Amazing Spider-Man (рус. Удивительный Человек-паук), выход которой продолжается до сих пор. За годы своего существования Питер Паркер был то робким учеником средней школы, то проблемным студентом колледжа, то женатым учителем, то главой мультимиллиардной компании, а также членом нескольких команд супергероев, таких как Мстители, Новые Мстители, Фантастическая четвёрка. Наиболее характерным образом Питера Паркера вне жизни Человека-паука является образ независимого фотографа, который использовался в комиксах на протяжении многих лет.
    """
}
