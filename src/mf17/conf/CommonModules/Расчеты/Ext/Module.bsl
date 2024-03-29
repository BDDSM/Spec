﻿
Процедура ЗаполнитьНаборЗаписей(ТекстЗапроса, Ссылка, НаборЗаписей) Экспорт
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(Ссылка.ПериодРегистрации));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(Ссылка.ПериодРегистрации));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Движение = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, Выборка);
	КонецЦикла;
КонецПроцедуры

Процедура РассчитатьЗаписиРегистраРасчета(НаборЗаписей, Выборка) Экспорт
	СпособРасчетаПоОкладу = Перечисления.СпособыРасчета.ПоОкладу;
	СпособРасчетаПоСреднему = Перечисления.СпособыРасчета.ПоСреднему;
	СпособРасчетаКомпенсацияЗаЛекарства = Перечисления.СпособыРасчета.КомпенсацияЗаЛекарства;
	СпособРасчетаПроцентом = Перечисления.СпособыРасчета.Процентом;
	КоличествоРабочихЧасов = Константы.КоличествоРабочихЧасов.Получить();
	
	Пока Выборка.Следующий() Цикл
		Запись = НаборЗаписей[Выборка.НомерСтроки-1];
		
		Результат = 0;
		
		Если Выборка.СпособРасчета = СпособРасчетаПоОкладу И Выборка.План <> 0 Тогда
			Результат = Запись.Размер * Выборка.Факт / Выборка.План;
			Запись.ОтработаноЧасов = Выборка.Факт * КоличествоРабочихЧасов;
		ИначеЕсли Выборка.СпособРасчета = СпособРасчетаПоСреднему И Выборка.ОтработаноЧасовБаза <> 0 Тогда
			Результат = Выборка.Факт * КоличествоРабочихЧасов * Выборка.РезультатБаза / Выборка.ОтработаноЧасовБаза;
			Запись.ОтработаноДней = Выборка.Факт;
		ИначеЕсли Выборка.СпособРасчета = СпособРасчетаКомпенсацияЗаЛекарства Тогда
			Результат = Мин(Запись.Размер * Выборка.ОтработаноДнейБаза, Выборка.ЛимитНаЛекарства);
		ИначеЕсли Выборка.СпособРасчета = СпособРасчетаПроцентом Тогда
			Результат = Выборка.РезультатБаза * Запись.Размер / 100;
		КонецЕсли;
		
		Запись.Результат = Результат;
	КонецЦикла;
КонецПроцедуры
