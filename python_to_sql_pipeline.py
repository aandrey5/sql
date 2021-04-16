import pandas as pd
import os
from sqlalchemy import create_engine, String, Integer, Float


months = ['январь', 'февраль', 'март', 'апрель', 'май', 'июнь', 'июль',
          'август', 'сентябрь', 'октябрь', 'ноябрь', 'март', 'апрель', 'май']


def get_month(filename):
    for m in months:
        if m in filename.lower():
            month = m
            break
    return month

def rename_columns(suffix, df, start_index, end_index):
    for i in range(start_index, end_index):
        df.columns.values[i] = f'{suffix}/{df.columns[i]}'


def fit_columns(df, sheetobj):
    for idx, col in enumerate(df.columns):
        series = df[col]
        max_len = max((
            series.astype(str).map(len).max(),
            len(str(series.name))
            )) + 1
        sheetobj.set_column(idx, idx, max_len)


DATA_DIR = 'data'
REPORT_FILE_NAME = 'АС2_Октябрь 2020.xls'
FILE_REPORT = os.path.join(DATA_DIR, REPORT_FILE_NAME)
NOMENCLATURE_FILE_NAME = 'Справочник номенклатуры.xlsx'
FILE_NOMENCLATURE = os.path.join(DATA_DIR, NOMENCLATURE_FILE_NAME)
PRICE_CATALOGUE_NAME = 'Справочник цен.xlsx'
FILE_PRICE_CATALOGUE = os.path.join(DATA_DIR, PRICE_CATALOGUE_NAME)

FILE_OUT_NAME = 'output.xlsx'
SHEET_OUT = 'отчет'
FILE_OUTPUT = os.path.join(DATA_DIR, FILE_OUT_NAME)

month = get_month(REPORT_FILE_NAME)
df_r = pd.read_excel(FILE_REPORT, sheet_name='Закуп')
new_header = df_r.iloc[1]
df_r = df_r[2:]
df_r.columns = new_header
parts = df_r.columns.get_loc("ИТОГО").tolist()
s = [i for i, x in list(enumerate(parts)) if x is True]
rename_columns('аптека', df_r, 3, s[0])
rename_columns('склад', df_r, s[0]+1, s[1])
df_r.drop(df_r.columns[s[0]], axis=1, inplace=True)
df_r = df_r.iloc[:, 2:len(df_r.columns)]

df_r = pd.melt(df_r, id_vars=['Наименование'], var_name='Поставщики', value_name="Закупки")
df_r = df_r[df_r.Закупки != ' ']

df_n = pd.read_excel(FILE_NOMENCLATURE, sheet_name='Сопоставление_НОМЕНКЛАТУРА')
df_n = df_n.filter(['Название препарата от контрагента', 'SOLO-код новый'])
df = pd.merge(df_r, df_n, how="left", left_on='Наименование', right_on='Название препарата от контрагента')
df.drop('Название препарата от контрагента', axis=1, inplace=True)
df_p = pd.read_excel(FILE_PRICE_CATALOGUE, sheet_name='уч цена')
df_p = df_p.filter(['solo-код', 'Учетная цена '])
df = pd.merge(df, df_p, how="left", left_on='SOLO-код новый', right_on='solo-код')
df = df.drop('solo-код', axis=1)
df['Сумма'] = df['Закупки'] * df['Учетная цена ']
df = df.drop('Учетная цена ', axis=1)
df[['Тип', 'Поставщики']] = df['Поставщики'].str.split('/', n=1, expand=True)
df.sort_values(['Наименование', 'Тип', 'Поставщики'], ascending=[True, True, True], inplace=True)
df.insert(1, 'Тип_temp', df['Тип'])
df.drop('Тип', axis=1, inplace=True)
df.rename(columns={'Тип_temp': 'Тип'}, inplace=True)
df.insert(0, 'Месяц', month)

df_x = df.fillna('')
writer = pd.ExcelWriter(FILE_OUTPUT)
df_x.to_excel(writer, sheet_name=SHEET_OUT, index=False)
worksheet = writer.sheets[SHEET_OUT]
fit_columns(df, worksheet)
writer.save()

# export to database
db_string_solo = 'postgresql://victor:4r5t6y7u8I@91.197.193.69:8297/victor_test'
db = create_engine(db_string_solo)
dtype = {'Месяц': String(length=20), 'Наименование': String(length=255),
         'Тип': String(length=10), 'Поставщики': String(length=255),
         'Закупки': Integer, 'SOLO-код новый': String(length=255),
         'Сумма': Float}

df.to_sql('report', con=db, if_exists='append', index=False, dtype=dtype)
