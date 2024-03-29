﻿
&НаКлиенте
Процедура Подбор(Команда)
	Отбор = Новый Структура;
	Отбор.Вставить("Склад", Объект.Склад);
	Отбор.Вставить("АдресВХ", ПоместитьТоварыВоВременноеХранилище());
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаПодбора", Отбор, ЭтаФорма);
КонецПроцедуры

&НаСервере
Функция ПоместитьТоварыВоВременноеХранилище()
	Возврат ПоместитьВоВременноеХранилище(Объект.Товары.Выгрузить(), УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура ОбработатьПодбор(АдресВХ) Экспорт
	ЗагрузитьТоварыИзВременногоХранилища(АдресВХ);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьТоварыИзВременногоХранилища(АдресВХ)
	// Правильнее будет сделать сканирование ТЧ и изменение количества уже имеющихся товаров
	
	Объект.Товары.Загрузить(ПолучитьИзВременногоХранилища(АдресВХ));
КонецПроцедуры
