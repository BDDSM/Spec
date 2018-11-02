﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.ОстаткиНоменклатуры.Записывать = Истина;
	Движения.СтоимостьТоваров.Записывать = Истина;
	
	Для Каждого ТекСтрокаТовары Из Товары Цикл
		// регистр ОстаткиНоменклатуры Приход
		Движение = Движения.ОстаткиНоменклатуры.ДобавитьПриход();
		Движение.Период			 = Дата;
		Движение.Номенклатура	 = ТекСтрокаТовары.Номенклатура;
		Движение.Склад			 = Склад;
		Движение.Количество		 = ТекСтрокаТовары.Количество;
		
		// регистр СтоимостьТоваров Приход
		Движение = Движения.СтоимостьТоваров.ДобавитьПриход();
		Движение.Период			 = Дата;
		Движение.Номенклатура	 = ТекСтрокаТовары.Номенклатура;
		Движение.Количество		 = ТекСтрокаТовары.Количество;
		Движение.Стоимость		 = ТекСтрокаТовары.Сумма;
	КонецЦикла;
КонецПроцедуры
