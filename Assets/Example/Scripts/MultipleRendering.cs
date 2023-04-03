using UnityEngine;
using UnityEngine.UI;
using TextTextureNative;

public class MultipleRendering : MonoBehaviour
{
    public Image image1;
    public Image image2;
    public Image image3;
    public Image image4;

    void Start()
    {
        image1.sprite = MakeSprite(1);
        image2.sprite = MakeSprite(2);
        image3.sprite = MakeSprite(3);
        image4.sprite = MakeSprite(4);
    }

    private Sprite MakeSprite(int index)
    {
        var uuid = $"image-{index}";
        var texture = TextTextureNativeManager.MakeTexture(uuid, 512, 512);
        TextTextureNativeManager.Render(uuid, uuid, 12 * index, Color.white, 2);
        return Sprite.Create(texture, new Rect(0, 0, texture.width, texture.height), Vector2.zero);
    }
}
