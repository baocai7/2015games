.class public final Lcom/ta/utdid2/core/persistent/c;
.super Ljava/lang/Object;


# static fields
.field private static final a:Ljava/lang/String; = "t"

.field private static final b:Ljava/lang/String; = "t2"


# instance fields
.field private c:Ljava/lang/String;

.field private d:Ljava/lang/String;

.field private e:Z

.field private f:Z

.field private g:Z

.field private h:Landroid/content/SharedPreferences;

.field private i:Lcom/ta/utdid2/core/persistent/b;

.field private j:Landroid/content/SharedPreferences$Editor;

.field private k:Lcom/ta/utdid2/core/persistent/b$a;

.field private l:Landroid/content/Context;

.field private m:Lcom/ta/utdid2/core/persistent/d;

.field private n:Z


# direct methods
.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V
    .locals 12

    const/4 v7, 0x1

    const/4 v1, 0x0

    const/4 v6, 0x0

    const-wide/16 v2, 0x0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const-string v0, ""

    iput-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->c:Ljava/lang/String;

    const-string v0, ""

    iput-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->d:Ljava/lang/String;

    iput-boolean v6, p0, Lcom/ta/utdid2/core/persistent/c;->e:Z

    iput-boolean v6, p0, Lcom/ta/utdid2/core/persistent/c;->f:Z

    iput-boolean v6, p0, Lcom/ta/utdid2/core/persistent/c;->g:Z

    iput-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    iput-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    iput-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    iput-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    iput-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->l:Landroid/content/Context;

    iput-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->m:Lcom/ta/utdid2/core/persistent/d;

    iput-boolean v6, p0, Lcom/ta/utdid2/core/persistent/c;->n:Z

    iput-boolean v6, p0, Lcom/ta/utdid2/core/persistent/c;->e:Z

    iput-boolean v7, p0, Lcom/ta/utdid2/core/persistent/c;->n:Z

    iput-object p3, p0, Lcom/ta/utdid2/core/persistent/c;->c:Ljava/lang/String;

    iput-object p2, p0, Lcom/ta/utdid2/core/persistent/c;->d:Ljava/lang/String;

    iput-object p1, p0, Lcom/ta/utdid2/core/persistent/c;->l:Landroid/content/Context;

    if-eqz p1, :cond_d

    invoke-virtual {p1, p3, v6}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    iput-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    const-string v1, "t"

    invoke-interface {v0, v1, v2, v3}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v0

    :goto_0
    invoke-static {}, Landroid/os/Environment;->getExternalStorageState()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_7

    const-string v5, "mounted"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_6

    iput-boolean v7, p0, Lcom/ta/utdid2/core/persistent/c;->g:Z

    iput-boolean v7, p0, Lcom/ta/utdid2/core/persistent/c;->f:Z

    :goto_1
    iget-boolean v4, p0, Lcom/ta/utdid2/core/persistent/c;->f:Z

    if-nez v4, :cond_0

    iget-boolean v4, p0, Lcom/ta/utdid2/core/persistent/c;->g:Z

    if-eqz v4, :cond_c

    :cond_0
    if-eqz p1, :cond_c

    invoke-static {p2}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_c

    invoke-direct {p0, p2}, Lcom/ta/utdid2/core/persistent/c;->b(Ljava/lang/String;)Lcom/ta/utdid2/core/persistent/d;

    move-result-object v4

    iput-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->m:Lcom/ta/utdid2/core/persistent/d;

    iget-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->m:Lcom/ta/utdid2/core/persistent/d;

    if-eqz v4, :cond_c

    :try_start_0
    iget-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->m:Lcom/ta/utdid2/core/persistent/d;

    invoke-virtual {v4, p3}, Lcom/ta/utdid2/core/persistent/d;->a(Ljava/lang/String;)Lcom/ta/utdid2/core/persistent/b;

    move-result-object v4

    iput-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    iget-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    const-string v5, "t"

    invoke-interface {v4, v5}, Lcom/ta/utdid2/core/persistent/b;->b(Ljava/lang/String;)J
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_2

    move-result-wide v4

    :try_start_1
    iget-object v6, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    const-string v7, "t2"

    const-wide/16 v8, 0x0

    invoke-interface {v6, v7, v8, v9}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_3

    move-result-wide v6

    :try_start_2
    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    const-string v1, "t2"

    invoke-interface {v0, v1}, Lcom/ta/utdid2/core/persistent/b;->b(Ljava/lang/String;)J
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_4

    move-result-wide v0

    cmp-long v4, v6, v0

    if-gez v4, :cond_8

    cmp-long v4, v6, v2

    if-lez v4, :cond_8

    :try_start_3
    iget-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    iget-object v5, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    invoke-static {v4, v5}, Lcom/ta/utdid2/core/persistent/c;->a(Landroid/content/SharedPreferences;Lcom/ta/utdid2/core/persistent/b;)V

    iget-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->m:Lcom/ta/utdid2/core/persistent/d;

    invoke-virtual {v4, p3}, Lcom/ta/utdid2/core/persistent/d;->a(Ljava/lang/String;)Lcom/ta/utdid2/core/persistent/b;

    move-result-object v4

    iput-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0

    :cond_1
    :goto_2
    cmp-long v4, v6, v0

    if-nez v4, :cond_2

    cmp-long v4, v6, v2

    if-nez v4, :cond_5

    cmp-long v4, v0, v2

    if-nez v4, :cond_5

    :cond_2
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    iget-boolean v8, p0, Lcom/ta/utdid2/core/persistent/c;->n:Z

    if-eqz v8, :cond_3

    iget-boolean v8, p0, Lcom/ta/utdid2/core/persistent/c;->n:Z

    if-eqz v8, :cond_5

    cmp-long v6, v6, v2

    if-nez v6, :cond_5

    cmp-long v0, v0, v2

    if-nez v0, :cond_5

    :cond_3
    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    if-eqz v0, :cond_4

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "t2"

    invoke-interface {v0, v1, v4, v5}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    :cond_4
    :try_start_4
    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    if-eqz v0, :cond_5

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    invoke-interface {v0}, Lcom/ta/utdid2/core/persistent/b;->c()Lcom/ta/utdid2/core/persistent/b$a;

    move-result-object v0

    const-string v1, "t2"

    invoke-interface {v0, v1, v4, v5}, Lcom/ta/utdid2/core/persistent/b$a;->a(Ljava/lang/String;J)Lcom/ta/utdid2/core/persistent/b$a;

    invoke-interface {v0}, Lcom/ta/utdid2/core/persistent/b$a;->b()Z
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_1

    :cond_5
    :goto_3
    return-void

    :cond_6
    const-string v5, "mounted_ro"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_7

    iput-boolean v7, p0, Lcom/ta/utdid2/core/persistent/c;->f:Z

    iput-boolean v6, p0, Lcom/ta/utdid2/core/persistent/c;->g:Z

    goto/16 :goto_1

    :cond_7
    iput-boolean v6, p0, Lcom/ta/utdid2/core/persistent/c;->g:Z

    iput-boolean v6, p0, Lcom/ta/utdid2/core/persistent/c;->f:Z

    goto/16 :goto_1

    :cond_8
    cmp-long v4, v6, v0

    if-lez v4, :cond_9

    cmp-long v4, v0, v2

    if-lez v4, :cond_9

    :try_start_5
    iget-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    iget-object v5, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    invoke-static {v4, v5}, Lcom/ta/utdid2/core/persistent/c;->a(Lcom/ta/utdid2/core/persistent/b;Landroid/content/SharedPreferences;)V

    const/4 v4, 0x0

    invoke-virtual {p1, p3, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v4

    iput-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    goto :goto_2

    :catch_0
    move-exception v4

    move-wide v4, v6

    :goto_4
    move-wide v6, v4

    goto :goto_2

    :cond_9
    cmp-long v4, v6, v2

    if-nez v4, :cond_a

    cmp-long v4, v0, v2

    if-lez v4, :cond_a

    iget-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    iget-object v5, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    invoke-static {v4, v5}, Lcom/ta/utdid2/core/persistent/c;->a(Lcom/ta/utdid2/core/persistent/b;Landroid/content/SharedPreferences;)V

    const/4 v4, 0x0

    invoke-virtual {p1, p3, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v4

    iput-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    goto/16 :goto_2

    :cond_a
    cmp-long v4, v0, v2

    if-nez v4, :cond_b

    cmp-long v4, v6, v2

    if-lez v4, :cond_b

    iget-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    iget-object v5, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    invoke-static {v4, v5}, Lcom/ta/utdid2/core/persistent/c;->a(Landroid/content/SharedPreferences;Lcom/ta/utdid2/core/persistent/b;)V

    iget-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->m:Lcom/ta/utdid2/core/persistent/d;

    invoke-virtual {v4, p3}, Lcom/ta/utdid2/core/persistent/d;->a(Ljava/lang/String;)Lcom/ta/utdid2/core/persistent/b;

    move-result-object v4

    iput-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    goto/16 :goto_2

    :cond_b
    cmp-long v4, v6, v0

    if-nez v4, :cond_1

    iget-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    iget-object v5, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    invoke-static {v4, v5}, Lcom/ta/utdid2/core/persistent/c;->a(Landroid/content/SharedPreferences;Lcom/ta/utdid2/core/persistent/b;)V

    iget-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->m:Lcom/ta/utdid2/core/persistent/d;

    invoke-virtual {v4, p3}, Lcom/ta/utdid2/core/persistent/d;->a(Ljava/lang/String;)Lcom/ta/utdid2/core/persistent/b;

    move-result-object v4

    iput-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_0

    goto/16 :goto_2

    :catch_1
    move-exception v0

    goto :goto_3

    :catch_2
    move-exception v4

    move-wide v4, v0

    move-wide v0, v2

    goto :goto_4

    :catch_3
    move-exception v6

    move-wide v10, v4

    move-wide v4, v0

    move-wide v0, v10

    goto :goto_4

    :catch_4
    move-exception v0

    move-wide v0, v4

    move-wide v4, v6

    goto :goto_4

    :cond_c
    move-wide v6, v0

    move-wide v0, v2

    goto/16 :goto_2

    :cond_d
    move-wide v0, v2

    goto/16 :goto_0
.end method

.method private static a(Landroid/content/SharedPreferences;Lcom/ta/utdid2/core/persistent/b;)V
    .locals 6

    if-eqz p0, :cond_6

    if-eqz p1, :cond_6

    invoke-interface {p1}, Lcom/ta/utdid2/core/persistent/b;->c()Lcom/ta/utdid2/core/persistent/b$a;

    move-result-object v2

    if-eqz v2, :cond_6

    invoke-interface {v2}, Lcom/ta/utdid2/core/persistent/b$a;->a()Lcom/ta/utdid2/core/persistent/b$a;

    invoke-interface {p0}, Landroid/content/SharedPreferences;->getAll()Ljava/util/Map;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_0
    :goto_0
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_5

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Map$Entry;

    invoke-interface {v0}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-interface {v0}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v0

    instance-of v4, v0, Ljava/lang/String;

    if-eqz v4, :cond_1

    check-cast v0, Ljava/lang/String;

    invoke-interface {v2, v1, v0}, Lcom/ta/utdid2/core/persistent/b$a;->a(Ljava/lang/String;Ljava/lang/String;)Lcom/ta/utdid2/core/persistent/b$a;

    goto :goto_0

    :cond_1
    instance-of v4, v0, Ljava/lang/Integer;

    if-eqz v4, :cond_2

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    invoke-interface {v2, v1, v0}, Lcom/ta/utdid2/core/persistent/b$a;->a(Ljava/lang/String;I)Lcom/ta/utdid2/core/persistent/b$a;

    goto :goto_0

    :cond_2
    instance-of v4, v0, Ljava/lang/Long;

    if-eqz v4, :cond_3

    check-cast v0, Ljava/lang/Long;

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v4

    invoke-interface {v2, v1, v4, v5}, Lcom/ta/utdid2/core/persistent/b$a;->a(Ljava/lang/String;J)Lcom/ta/utdid2/core/persistent/b$a;

    goto :goto_0

    :cond_3
    instance-of v4, v0, Ljava/lang/Float;

    if-eqz v4, :cond_4

    check-cast v0, Ljava/lang/Float;

    invoke-virtual {v0}, Ljava/lang/Float;->floatValue()F

    move-result v0

    invoke-interface {v2, v1, v0}, Lcom/ta/utdid2/core/persistent/b$a;->a(Ljava/lang/String;F)Lcom/ta/utdid2/core/persistent/b$a;

    goto :goto_0

    :cond_4
    instance-of v4, v0, Ljava/lang/Boolean;

    if-eqz v4, :cond_0

    check-cast v0, Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    invoke-interface {v2, v1, v0}, Lcom/ta/utdid2/core/persistent/b$a;->a(Ljava/lang/String;Z)Lcom/ta/utdid2/core/persistent/b$a;

    goto :goto_0

    :cond_5
    invoke-interface {v2}, Lcom/ta/utdid2/core/persistent/b$a;->b()Z

    :cond_6
    return-void
.end method

.method private static a(Lcom/ta/utdid2/core/persistent/b;Landroid/content/SharedPreferences;)V
    .locals 6

    if-eqz p0, :cond_6

    if-eqz p1, :cond_6

    invoke-interface {p1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    if-eqz v2, :cond_6

    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->clear()Landroid/content/SharedPreferences$Editor;

    invoke-interface {p0}, Lcom/ta/utdid2/core/persistent/b;->b()Ljava/util/Map;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_0
    :goto_0
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_5

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Map$Entry;

    invoke-interface {v0}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-interface {v0}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v0

    instance-of v4, v0, Ljava/lang/String;

    if-eqz v4, :cond_1

    check-cast v0, Ljava/lang/String;

    invoke-interface {v2, v1, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    goto :goto_0

    :cond_1
    instance-of v4, v0, Ljava/lang/Integer;

    if-eqz v4, :cond_2

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    invoke-interface {v2, v1, v0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    goto :goto_0

    :cond_2
    instance-of v4, v0, Ljava/lang/Long;

    if-eqz v4, :cond_3

    check-cast v0, Ljava/lang/Long;

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v4

    invoke-interface {v2, v1, v4, v5}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    goto :goto_0

    :cond_3
    instance-of v4, v0, Ljava/lang/Float;

    if-eqz v4, :cond_4

    check-cast v0, Ljava/lang/Float;

    invoke-virtual {v0}, Ljava/lang/Float;->floatValue()F

    move-result v0

    invoke-interface {v2, v1, v0}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    goto :goto_0

    :cond_4
    instance-of v4, v0, Ljava/lang/Boolean;

    if-eqz v4, :cond_0

    check-cast v0, Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    invoke-interface {v2, v1, v0}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    goto :goto_0

    :cond_5
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->commit()Z

    :cond_6
    return-void
.end method

.method private a(Ljava/lang/String;F)V
    .locals 1

    invoke-static {p1}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "t"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    invoke-direct {p0}, Lcom/ta/utdid2/core/persistent/c;->c()V

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    :cond_0
    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    invoke-interface {v0, p1, p2}, Lcom/ta/utdid2/core/persistent/b$a;->a(Ljava/lang/String;F)Lcom/ta/utdid2/core/persistent/b$a;

    :cond_1
    return-void
.end method

.method private a(Ljava/lang/String;I)V
    .locals 1

    invoke-static {p1}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "t"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    invoke-direct {p0}, Lcom/ta/utdid2/core/persistent/c;->c()V

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    :cond_0
    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    invoke-interface {v0, p1, p2}, Lcom/ta/utdid2/core/persistent/b$a;->a(Ljava/lang/String;I)Lcom/ta/utdid2/core/persistent/b$a;

    :cond_1
    return-void
.end method

.method private a(Ljava/lang/String;Z)V
    .locals 1

    invoke-static {p1}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "t"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    invoke-direct {p0}, Lcom/ta/utdid2/core/persistent/c;->c()V

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    :cond_0
    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    invoke-interface {v0, p1, p2}, Lcom/ta/utdid2/core/persistent/b$a;->a(Ljava/lang/String;Z)Lcom/ta/utdid2/core/persistent/b$a;

    :cond_1
    return-void
.end method

.method private b(Ljava/lang/String;)Lcom/ta/utdid2/core/persistent/d;
    .locals 6

    const/4 v0, 0x0

    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v2

    if-eqz v2, :cond_2

    new-instance v1, Ljava/io/File;

    const-string v3, "%s%s%s"

    const/4 v4, 0x3

    new-array v4, v4, [Ljava/lang/Object;

    const/4 v5, 0x0

    invoke-virtual {v2}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v2

    aput-object v2, v4, v5

    const/4 v2, 0x1

    sget-object v5, Ljava/io/File;->separator:Ljava/lang/String;

    aput-object v5, v4, v2

    const/4 v2, 0x2

    aput-object p1, v4, v2

    invoke-static {v3, v4}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v2

    if-nez v2, :cond_0

    invoke-virtual {v1}, Ljava/io/File;->mkdirs()Z

    :cond_0
    :goto_0
    if-eqz v1, :cond_1

    new-instance v0, Lcom/ta/utdid2/core/persistent/d;

    invoke-virtual {v1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Lcom/ta/utdid2/core/persistent/d;-><init>(Ljava/lang/String;)V

    iput-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->m:Lcom/ta/utdid2/core/persistent/d;

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->m:Lcom/ta/utdid2/core/persistent/d;

    :cond_1
    return-object v0

    :cond_2
    move-object v1, v0

    goto :goto_0
.end method

.method private b()Z
    .locals 1

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    invoke-interface {v0}, Lcom/ta/utdid2/core/persistent/b;->a()Z

    move-result v0

    if-nez v0, :cond_0

    invoke-virtual {p0}, Lcom/ta/utdid2/core/persistent/c;->a()Z

    :cond_0
    :goto_0
    return v0

    :cond_1
    const/4 v0, 0x0

    goto :goto_0
.end method

.method private static c(Ljava/lang/String;)Ljava/io/File;
    .locals 5

    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v1

    if-eqz v1, :cond_1

    new-instance v0, Ljava/io/File;

    const-string v2, "%s%s%s"

    const/4 v3, 0x3

    new-array v3, v3, [Ljava/lang/Object;

    const/4 v4, 0x0

    invoke-virtual {v1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v1

    aput-object v1, v3, v4

    const/4 v1, 0x1

    sget-object v4, Ljava/io/File;->separator:Ljava/lang/String;

    aput-object v4, v3, v1

    const/4 v1, 0x2

    aput-object p0, v3, v1

    invoke-static {v2, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v1

    if-nez v1, :cond_0

    invoke-virtual {v0}, Ljava/io/File;->mkdirs()Z

    :cond_0
    :goto_0
    return-object v0

    :cond_1
    const/4 v0, 0x0

    goto :goto_0
.end method

.method private c()V
    .locals 1

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    iput-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    :cond_0
    iget-boolean v0, p0, Lcom/ta/utdid2/core/persistent/c;->g:Z

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    if-nez v0, :cond_1

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    invoke-interface {v0}, Lcom/ta/utdid2/core/persistent/b;->c()Lcom/ta/utdid2/core/persistent/b$a;

    move-result-object v0

    iput-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    :cond_1
    invoke-direct {p0}, Lcom/ta/utdid2/core/persistent/c;->b()Z

    return-void
.end method

.method private d()V
    .locals 3

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->l:Landroid/content/Context;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->l:Landroid/content/Context;

    iget-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->c:Ljava/lang/String;

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    iput-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    :cond_0
    invoke-static {}, Landroid/os/Environment;->getExternalStorageState()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_2

    const-string v1, "mounted"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_1

    const-string v1, "mounted_ro"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    if-eqz v0, :cond_2

    :cond_1
    :try_start_0
    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->m:Lcom/ta/utdid2/core/persistent/d;

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->m:Lcom/ta/utdid2/core/persistent/d;

    iget-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->c:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lcom/ta/utdid2/core/persistent/d;->a(Ljava/lang/String;)Lcom/ta/utdid2/core/persistent/b;

    move-result-object v0

    iput-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :cond_2
    :goto_0
    return-void

    :catch_0
    move-exception v0

    goto :goto_0
.end method

.method private d(Ljava/lang/String;)V
    .locals 1

    invoke-static {p1}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "t"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    invoke-direct {p0}, Lcom/ta/utdid2/core/persistent/c;->c()V

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0, p1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    :cond_0
    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    invoke-interface {v0, p1}, Lcom/ta/utdid2/core/persistent/b$a;->a(Ljava/lang/String;)Lcom/ta/utdid2/core/persistent/b$a;

    :cond_1
    return-void
.end method

.method private e(Ljava/lang/String;)I
    .locals 2

    const/4 v0, 0x0

    invoke-direct {p0}, Lcom/ta/utdid2/core/persistent/c;->b()Z

    iget-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    if-eqz v1, :cond_1

    iget-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    invoke-interface {v1, p1, v0}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    :cond_0
    :goto_0
    return v0

    :cond_1
    iget-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    if-eqz v1, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    invoke-interface {v0, p1}, Lcom/ta/utdid2/core/persistent/b;->a(Ljava/lang/String;)I

    move-result v0

    goto :goto_0
.end method

.method private e()V
    .locals 4

    invoke-direct {p0}, Lcom/ta/utdid2/core/persistent/c;->c()V

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    if-eqz v2, :cond_0

    iget-object v2, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->clear()Landroid/content/SharedPreferences$Editor;

    iget-object v2, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    const-string v3, "t"

    invoke-interface {v2, v3, v0, v1}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    :cond_0
    iget-object v2, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    if-eqz v2, :cond_1

    iget-object v2, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    invoke-interface {v2}, Lcom/ta/utdid2/core/persistent/b$a;->a()Lcom/ta/utdid2/core/persistent/b$a;

    iget-object v2, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    const-string v3, "t"

    invoke-interface {v2, v3, v0, v1}, Lcom/ta/utdid2/core/persistent/b$a;->a(Ljava/lang/String;J)Lcom/ta/utdid2/core/persistent/b$a;

    :cond_1
    return-void
.end method

.method private f(Ljava/lang/String;)J
    .locals 3

    const-wide/16 v0, 0x0

    invoke-direct {p0}, Lcom/ta/utdid2/core/persistent/c;->b()Z

    iget-object v2, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    if-eqz v2, :cond_1

    iget-object v2, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    invoke-interface {v2, p1, v0, v1}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v0

    :cond_0
    :goto_0
    return-wide v0

    :cond_1
    iget-object v2, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    if-eqz v2, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    invoke-interface {v0, p1}, Lcom/ta/utdid2/core/persistent/b;->b(Ljava/lang/String;)J

    move-result-wide v0

    goto :goto_0
.end method

.method private f()Ljava/util/Map;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Map",
            "<",
            "Ljava/lang/String;",
            "*>;"
        }
    .end annotation

    invoke-direct {p0}, Lcom/ta/utdid2/core/persistent/c;->b()Z

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->getAll()Ljava/util/Map;

    move-result-object v0

    :goto_0
    return-object v0

    :cond_0
    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    invoke-interface {v0}, Lcom/ta/utdid2/core/persistent/b;->b()Ljava/util/Map;

    move-result-object v0

    goto :goto_0

    :cond_1
    const/4 v0, 0x0

    goto :goto_0
.end method

.method private g(Ljava/lang/String;)F
    .locals 2

    const/4 v0, 0x0

    invoke-direct {p0}, Lcom/ta/utdid2/core/persistent/c;->b()Z

    iget-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    if-eqz v1, :cond_1

    iget-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    invoke-interface {v1, p1, v0}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result v0

    :cond_0
    :goto_0
    return v0

    :cond_1
    iget-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    if-eqz v1, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    invoke-interface {v0, p1}, Lcom/ta/utdid2/core/persistent/b;->c(Ljava/lang/String;)F

    move-result v0

    goto :goto_0
.end method

.method private h(Ljava/lang/String;)Z
    .locals 2

    const/4 v0, 0x0

    invoke-direct {p0}, Lcom/ta/utdid2/core/persistent/c;->b()Z

    iget-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    if-eqz v1, :cond_1

    iget-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    invoke-interface {v1, p1, v0}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    :cond_0
    :goto_0
    return v0

    :cond_1
    iget-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    if-eqz v1, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    invoke-interface {v0, p1}, Lcom/ta/utdid2/core/persistent/b;->d(Ljava/lang/String;)Z

    move-result v0

    goto :goto_0
.end method


# virtual methods
.method public final a(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    invoke-direct {p0}, Lcom/ta/utdid2/core/persistent/c;->b()Z

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    const-string v1, ""

    invoke-interface {v0, p1, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_0

    :goto_0
    return-object v0

    :cond_0
    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    const-string v1, ""

    invoke-interface {v0, p1, v1}, Lcom/ta/utdid2/core/persistent/b;->a(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :cond_1
    const-string v0, ""

    goto :goto_0
.end method

.method public final a(Ljava/lang/String;J)V
    .locals 1

    invoke-static {p1}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "t"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    invoke-direct {p0}, Lcom/ta/utdid2/core/persistent/c;->c()V

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0, p1, p2, p3}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    :cond_0
    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    invoke-interface {v0, p1, p2, p3}, Lcom/ta/utdid2/core/persistent/b$a;->a(Ljava/lang/String;J)Lcom/ta/utdid2/core/persistent/b$a;

    :cond_1
    return-void
.end method

.method public final a(Ljava/lang/String;Ljava/lang/String;)V
    .locals 1

    invoke-static {p1}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "t"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    invoke-direct {p0}, Lcom/ta/utdid2/core/persistent/c;->c()V

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    invoke-interface {v0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    :cond_0
    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    invoke-interface {v0, p1, p2}, Lcom/ta/utdid2/core/persistent/b$a;->a(Ljava/lang/String;Ljava/lang/String;)Lcom/ta/utdid2/core/persistent/b$a;

    :cond_1
    return-void
.end method

.method public final a()Z
    .locals 6

    const/4 v1, 0x0

    const/4 v0, 0x1

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    iget-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    if-eqz v4, :cond_1

    iget-boolean v4, p0, Lcom/ta/utdid2/core/persistent/c;->n:Z

    if-nez v4, :cond_0

    iget-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    if-eqz v4, :cond_0

    iget-object v4, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    const-string v5, "t"

    invoke-interface {v4, v5, v2, v3}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    :cond_0
    iget-object v2, p0, Lcom/ta/utdid2/core/persistent/c;->j:Landroid/content/SharedPreferences$Editor;

    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->commit()Z

    move-result v2

    if-nez v2, :cond_1

    move v0, v1

    :cond_1
    iget-object v2, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    if-eqz v2, :cond_2

    iget-object v2, p0, Lcom/ta/utdid2/core/persistent/c;->l:Landroid/content/Context;

    if-eqz v2, :cond_2

    iget-object v2, p0, Lcom/ta/utdid2/core/persistent/c;->l:Landroid/content/Context;

    iget-object v3, p0, Lcom/ta/utdid2/core/persistent/c;->c:Ljava/lang/String;

    invoke-virtual {v2, v3, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v2

    iput-object v2, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    :cond_2
    invoke-static {}, Landroid/os/Environment;->getExternalStorageState()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_5

    const-string v3, "mounted"

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_3

    iget-object v3, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    if-nez v3, :cond_7

    iget-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->d:Ljava/lang/String;

    invoke-direct {p0, v1}, Lcom/ta/utdid2/core/persistent/c;->b(Ljava/lang/String;)Lcom/ta/utdid2/core/persistent/d;

    move-result-object v1

    if-eqz v1, :cond_3

    iget-object v3, p0, Lcom/ta/utdid2/core/persistent/c;->c:Ljava/lang/String;

    invoke-virtual {v1, v3}, Lcom/ta/utdid2/core/persistent/d;->a(Ljava/lang/String;)Lcom/ta/utdid2/core/persistent/b;

    move-result-object v1

    iput-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    iget-boolean v1, p0, Lcom/ta/utdid2/core/persistent/c;->n:Z

    if-nez v1, :cond_6

    iget-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    iget-object v3, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    invoke-static {v1, v3}, Lcom/ta/utdid2/core/persistent/c;->a(Landroid/content/SharedPreferences;Lcom/ta/utdid2/core/persistent/b;)V

    :goto_0
    iget-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    invoke-interface {v1}, Lcom/ta/utdid2/core/persistent/b;->c()Lcom/ta/utdid2/core/persistent/b$a;

    move-result-object v1

    iput-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    :cond_3
    :goto_1
    const-string v1, "mounted"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_4

    const-string v1, "mounted_ro"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_5

    iget-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    if-eqz v1, :cond_5

    :cond_4
    :try_start_0
    iget-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->m:Lcom/ta/utdid2/core/persistent/d;

    if-eqz v1, :cond_5

    iget-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->m:Lcom/ta/utdid2/core/persistent/d;

    iget-object v2, p0, Lcom/ta/utdid2/core/persistent/c;->c:Ljava/lang/String;

    invoke-virtual {v1, v2}, Lcom/ta/utdid2/core/persistent/d;->a(Ljava/lang/String;)Lcom/ta/utdid2/core/persistent/b;

    move-result-object v1

    iput-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :cond_5
    :goto_2
    return v0

    :cond_6
    iget-object v1, p0, Lcom/ta/utdid2/core/persistent/c;->i:Lcom/ta/utdid2/core/persistent/b;

    iget-object v3, p0, Lcom/ta/utdid2/core/persistent/c;->h:Landroid/content/SharedPreferences;

    invoke-static {v1, v3}, Lcom/ta/utdid2/core/persistent/c;->a(Lcom/ta/utdid2/core/persistent/b;Landroid/content/SharedPreferences;)V

    goto :goto_0

    :cond_7
    iget-object v3, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    if-eqz v3, :cond_3

    iget-object v3, p0, Lcom/ta/utdid2/core/persistent/c;->k:Lcom/ta/utdid2/core/persistent/b$a;

    invoke-interface {v3}, Lcom/ta/utdid2/core/persistent/b$a;->b()Z

    move-result v3

    if-nez v3, :cond_3

    move v0, v1

    goto :goto_1

    :catch_0
    move-exception v1

    goto :goto_2
.end method
