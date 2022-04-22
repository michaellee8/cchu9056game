using System;
using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography.X509Certificates;
using UnityEngine;
using Votanic.vXR.vGear;

public class DisableRigidBody : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
    }

    public Vector3 snapPosition;
    public Quaternion snapRotation;

    private int _collidingCount;

    private int _prevCollidingCount;

    public void DisableRigidBodyNow()
    {
        GetComponent<Rigidbody>().useGravity = false;
        GetComponent<Rigidbody>().detectCollisions = true;
        GetComponent<Rigidbody>().isKinematic = true;
    }

    public void EnableRigidBodyNow()
    {
        GetComponent<Rigidbody>().useGravity = true;
        GetComponent<Rigidbody>().detectCollisions = true;
        GetComponent<Rigidbody>().isKinematic = true;
    }

    public void OnVGearCollisionStaying()
    {
        if (_collidingCount <= 50)
        {
            _collidingCount += 5;
        }
    }

    private void LateUpdate()
    {
        var vGear = GetComponent<vGear_Interactables>();
        if (_collidingCount >= -15)
        {
            _collidingCount -= 2;
        }

        if (_collidingCount > 0 && !vGear.isGrabbed)
        {
            SnapToPosition();
        }
    }

    private void FixedUpdate()
    {
        var vGear = GetComponent<vGear_Interactables>();


        if (_collidingCount > 0)
        {
            DisableRigidBodyNow();
        }
        else
        {
            EnableRigidBodyNow();
        }

        _prevCollidingCount = _collidingCount;

        // if (vGear.isGrabbed)
        // {
        //     _collidingCount = -6;
        // }
    }

    private void SnapToPosition()
    {
        GetComponent<Transform>().position = snapPosition;

        GetComponent<Transform>().rotation = snapRotation;
    }
}