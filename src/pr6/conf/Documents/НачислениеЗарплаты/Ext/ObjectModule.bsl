﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	НаборОсновныеНачисления = Движения.ОсновныеНачисления;
	НаборДополнительныеНачисления = Движения.ДополнительныеНачисления;
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	ОсновныеНачисления.Ссылка.ПериодРегистрации КАК ПериодРегистрации,
		|	ОсновныеНачисления.Сотрудник КАК Сотрудник,
		|	ОсновныеНачисления.Подразделение КАК Подразделение,
		|	ОсновныеНачисления.ВидРасчета КАК ВидРасчета,
		|	ОсновныеНачисления.ПериодДействияНачало КАК ПериодДействияНачало,
		|	КОНЕЦПЕРИОДА(ОсновныеНачисления.ПериодДействияКонец, ДЕНЬ) КАК ПериодДействияКонец,
		|	ОсновныеНачисления.БазовыйПериодНачало КАК БазовыйПериодНачало,
		|	ВЫБОР ОсновныеНачисления.БазовыйПериодКонец
		|		КОГДА ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ОсновныеНачисления.БазовыйПериодКонец
		|		ИНАЧЕ КОНЕЦПЕРИОДА(ОсновныеНачисления.БазовыйПериодКонец, ДЕНЬ)
		|	КОНЕЦ КАК БазовыйПериодКонец,
		|	ОсновныеНачисления.График КАК График,
		|	РАЗНОСТЬДАТ(ОсновныеНачисления.ПериодДействияНачало, ОсновныеНачисления.ПериодДействияКонец, МЕСЯЦ) КАК КоличествоМесяцев
		|ИЗ
		|	Документ.НачислениеЗарплаты.ОсновныеНачисления КАК ОсновныеНачисления
		|ГДЕ
		|	ОсновныеНачисления.Ссылка = &Ссылка";
	
	Расчеты.ЗаполнитьНаборЗаписей(ТекстЗапроса, Ссылка, НаборОсновныеНачисления);
	
	ТаблицаСторноЗаписей = НаборОсновныеНачисления.ПолучитьДополнение();
	Для Каждого СтрокаСторно Из ТаблицаСторноЗаписей Цикл
		ДобавитьСтрокуСторно(НаборОсновныеНачисления, СтрокаСторно);
	КонецЦикла;
	
	НаборОсновныеНачисления.Записать(, Ложь);
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	ДополнительныеНачисления.Ссылка.ПериодРегистрации КАК ПериодРегистрации,
		|	ДополнительныеНачисления.Сотрудник КАК Сотрудник,
		|	ДополнительныеНачисления.Подразделение КАК Подразделение,
		|	ДополнительныеНачисления.ВидРасчета КАК ВидРасчета,
		|	ДополнительныеНачисления.БазовыйПериодНачало КАК БазовыйПериодНачало,
		|	ВЫБОР ДополнительныеНачисления.БазовыйПериодКонец
		|		КОГДА ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ДополнительныеНачисления.БазовыйПериодКонец
		|		ИНАЧЕ КОНЕЦПЕРИОДА(ДополнительныеНачисления.БазовыйПериодКонец, ДЕНЬ)
		|	КОНЕЦ КАК БазовыйПериодКонец,
		|	ДополнительныеНачисления.Размер КАК Размер
		|ИЗ
		|	Документ.НачислениеЗарплаты.ДополнительныеНачисления КАК ДополнительныеНачисления
		|ГДЕ
		|	ДополнительныеНачисления.Ссылка = &Ссылка";
	
	Расчеты.ЗаполнитьНаборЗаписей(ТекстЗапроса, Ссылка, НаборДополнительныеНачисления);
	НаборДополнительныеНачисления.Записать(, Ложь);
	
	Измерения = Новый Массив;
	Измерения.Добавить("Сотрудник");
	Измерения.Добавить("Подразделение");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	Запрос.УстановитьПараметр("Измерения", Измерения);
	
	РассчитатьОсновныеНачисления(НаборОсновныеНачисления, Запрос);
	РассчитатьДополнительныеНачисления(НаборДополнительныеНачисления, Запрос);
КонецПроцедуры

Процедура ДобавитьСтрокуСторно(НаборЗаписей, СтрокаСторно)
	ЗаписьРегистра = НаборЗаписей.Добавить();
	
	ЗаполнитьЗначенияСвойств(ЗаписьРегистра, СтрокаСторно);
	
	ЗаписьРегистра.ПериодРегистрации	 = СтрокаСторно.ПериодРегистрацииСторно;
	ЗаписьРегистра.ПериодДействияНачало	 = СтрокаСторно.ПериодДействияНачалоСторно;
	ЗаписьРегистра.ПериодДействияКонец	 = СтрокаСторно.ПериодДействияКонецСторно;
	ЗаписьРегистра.Сторно				 = Истина;
КонецПроцедуры

Процедура РассчитатьОсновныеНачисления(НаборОсновныеНачисления, Запрос)
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеГрафика.НомерСтроки КАК НомерСтроки,
		|	ДанныеГрафика.Подразделение КАК Подразделение,
		|	ДанныеГрафика.ЗначениеФактическийПериодДействия КАК Факт,
		|	ДанныеГрафика.ЗначениеБазовыйПериод КАК ПланПредыдущегоПериода,
		|	МИНИМУМ(ШкалаОкладов.КоличествоЧасов) КАК КоличествоЧасов
		|ПОМЕСТИТЬ втОклады
		|ИЗ
		|	РегистрРасчета.ОсновныеНачисления.ДанныеГрафика(Регистратор = &Регистратор) КАК ДанныеГрафика
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШкалаОкладов КАК ШкалаОкладов
		|		ПО ДанныеГрафика.Подразделение = ШкалаОкладов.Подразделение
		|			И ДанныеГрафика.ЗначениеФактическийПериодДействия < ШкалаОкладов.КоличествоЧасов
		|			И (ДанныеГрафика.ВидРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисления.Оклад))
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеГрафика.Подразделение,
		|	ДанныеГрафика.НомерСтроки,
		|	ДанныеГрафика.ЗначениеФактическийПериодДействия,
		|	ДанныеГрафика.ЗначениеБазовыйПериод
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОсновныеНачисления.НомерСтроки КАК НомерСтроки,
		|	ОсновныеНачисления.ВидРасчета КАК ВидРасчета,
		|	втОклады.Факт КАК Факт,
		|	втОклады.ПланПредыдущегоПериода КАК ПланПредыдущегоПериода,
		|	ШкалаОкладов.Оклад КАК Оклад,
		|	ЕСТЬNULL(БазаОсновныеНачисления.РезультатБаза, 0) + ЕСТЬNULL(БазаДополнительныеНачисления.РезультатБаза, 0) КАК РезультатБаза
		|ИЗ
		|	РегистрРасчета.ОсновныеНачисления КАК ОсновныеНачисления
		|		ЛЕВОЕ СОЕДИНЕНИЕ втОклады КАК втОклады
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШкалаОкладов КАК ШкалаОкладов
		|			ПО втОклады.Подразделение = ШкалаОкладов.Подразделение
		|				И втОклады.КоличествоЧасов = ШкалаОкладов.КоличествоЧасов
		|		ПО ОсновныеНачисления.НомерСтроки = втОклады.НомерСтроки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисления.БазаОсновныеНачисления(&Измерения, &Измерения, , Регистратор = &Регистратор) КАК БазаОсновныеНачисления
		|		ПО ОсновныеНачисления.НомерСтроки = БазаОсновныеНачисления.НомерСтроки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисления.БазаДополнительныеНачисления(&Измерения, &Измерения, , Регистратор = &Регистратор) КАК БазаДополнительныеНачисления
		|		ПО ОсновныеНачисления.НомерСтроки = БазаДополнительныеНачисления.НомерСтроки
		|ГДЕ
		|	ОсновныеНачисления.Регистратор = &Регистратор";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Расчеты.РассчитатьЗаписиРегистраРасчета(НаборОсновныеНачисления, Выборка);
	НаборОсновныеНачисления.Записать(, Истина);
КонецПроцедуры

Процедура РассчитатьДополнительныеНачисления(НаборДополнительныеНачисления, Запрос)
	Запрос.Текст =
		"ВЫБРАТЬ
		|	БазаОсновныеНачисления.НомерСтроки КАК НомерСтроки,
		|	БазаОсновныеНачисления.ВидРасчета КАК ВидРасчета,
		|	БазаОсновныеНачисления.РезультатБаза КАК РезультатБаза
		|ИЗ
		|	РегистрРасчета.ДополнительныеНачисления.БазаОсновныеНачисления(&Измерения, &Измерения, , Регистратор = &Регистратор) КАК БазаОсновныеНачисления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Расчеты.РассчитатьЗаписиРегистраРасчета(НаборДополнительныеНачисления, Выборка);
	НаборДополнительныеНачисления.Записать(, Истина);
КонецПроцедуры
